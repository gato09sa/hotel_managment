#!/usr/bin/env python3
"""Reproduce scripts on MySQL 8.0 in an isolated hotel_management_test database.

Reconstructs cases from pj2.pdf; these are NOT the original executed statements.
TC-12 is manual (container stop/start). TC-05 intentionally demonstrates a weakness.
"""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent.parent
SCHEMA = 'hotel_management_test'
ERROR_CODES = {13:'1048', 15:'1062', 16:'3819', 17:'3819', 18:'3819'}

def mysql(sql: str):
    user = os.getenv('HOTEL_MYSQL_USER','root')
    mode = os.getenv('HOTEL_MYSQL_MODE','docker')
    env = os.environ.copy()
    password = os.getenv('HOTEL_MYSQL_PASSWORD','')
    if mode == 'docker':
        container = os.getenv('HOTEL_MYSQL_CONTAINER','mysqlcontainer2')
        cmd = ['docker','exec','-i']
        if password:
            # The password remains local; never upload it to GitHub.
            cmd += ['--env',f'MYSQL_PWD={password}']
        cmd += [container,'mysql','--batch','--skip-column-names','-u',user]
    else:
        cmd = ['mysql','--batch','--skip-column-names','-u',user]
        if password:
            env['MYSQL_PWD']=password
        cmd += ['-h',os.getenv('HOTEL_MYSQL_HOST','127.0.0.1'),
                '-P',os.getenv('HOTEL_MYSQL_PORT','3306')]
    start = time.monotonic()
    result = subprocess.run(cmd, input=sql, text=True, capture_output=True, env=env)
    return result, time.monotonic()-start

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--reset-test-db',action='store_true',help='Explicitly reset hotel_management_test (never hotel_management).')
    args=parser.parse_args()
    if not args.reset_test_db:
        parser.error('Pass --reset-test-db to acknowledge replacement of isolated test database')
    if not shutil.which('docker' if os.getenv('HOTEL_MYSQL_MODE','docker')=='docker' else 'mysql'):
        sys.exit('Missing Docker or mysql client. See README.md')
    result,_=mysql('DROP DATABASE IF EXISTS '+SCHEMA+'; CREATE DATABASE '+SCHEMA+' CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
    if result.returncode:
        sys.exit('Cannot reset test database: '+result.stderr)
    for path in (ROOT/'database/01_schema.sql',ROOT/'database/02_sample_data.sql'):
        sql=path.read_text(encoding='utf-8')
        sql=re.sub(r'\bhotel_management\b',SCHEMA,sql)
        result,_=mysql(sql)
        if result.returncode:
            sys.exit(f'Error loading {path.name}:\n'+result.stderr)
    ok=0
    for i in range(1,19):
        path=ROOT/f'tests/sql/TC-{i:02d}.sql'
        if i==12:
            print('TC-12 MANUAL (see tests/TC-12_manual.md): requires controlled Docker restart')
            continue
        result,duration=mysql(path.read_text(encoding='utf-8'))
        out=result.stdout+result.stderr
        if i in ERROR_CODES:
            expected=ERROR_CODES[i]
            passed=result.returncode!=0 and bool(re.search(r'ERROR\s+'+expected+r'\b',out))
            status='EXPECTED_REJECTION' if passed else 'FAIL'
        elif i==11:
            passed=result.returncode==0 and 'SMOKE_TC_11' in out
            status=f'SMOKE_ONLY ({duration:.3f} s, not a concurrent-load benchmark)' if passed else 'FAIL'
        else:
            token='PASS_TC_05_LIMITATION_DOCUMENTED' if i==5 else f'PASS_TC_{i:02d}'
            passed=result.returncode==0 and token in out and f'FAIL_TC_{i:02d}' not in out
            status='DETECTION_ONLY_KNOWN_LIMITATION' if passed and i==5 else ('PASS' if passed else 'FAIL')
        ok += passed
        print(f'TC-{i:02d}: {status}')
        if not passed:
            print(out[-1800:])
    print(f'Validated {ok}/17 automatically executed cases; TC-12 manual.')
    if ok!=17:
        sys.exit(1)

if __name__=='__main__':
    main()
