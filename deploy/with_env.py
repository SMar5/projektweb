#!/usr/bin/env python3
"""Wczytuje parametry z SSM Parameter Store do środowiska i uruchamia komendę.
/nforum/prod/SECRET_KEY  ->  zmienna środowiskowa SECRET_KEY
Użycie: with_env.py <komenda> [argumenty...]
"""
import os
import sys
import boto3
PREFIX = os.environ.get("SSM_PREFIX", "/nforum/prod/")
REGION = os.environ.get("AWS_REGION", "eu-north-1")
def load():
    ssm = boto3.client("ssm", region_name=REGION)
    pages = ssm.get_paginator("get_parameters_by_path").paginate(
        Path=PREFIX, Recursive=True, WithDecryption=True
    )
    for page in pages:
        for param in page["Parameters"]:
            os.environ[param["Name"][len(PREFIX):]] = param["Value"]
if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("użycie: with_env.py <komenda> [argumenty...]")
    load()
    os.execvp(sys.argv[1], sys.argv[1:])