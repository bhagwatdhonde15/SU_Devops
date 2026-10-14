#!/usr/bin/env python3
"""
Enterprise Smart Library Management Platform - API Integration Test Suite
Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
"""

import sys
import json
import urllib.request
import urllib.error

def test_endpoint(url, expected_code=200):
    print(f"Testing GET {url} ...", end=" ")
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "TestClient/1.0"})
        with urllib.request.urlopen(req) as resp:
            status = resp.status
            body = json.loads(resp.read().decode("utf-8"))
            if status == expected_code:
                print(f"[PASSED] (HTTP {status})")
                print("Response:", json.dumps(body, indent=2))
                return True, body
            else:
                print(f"[FAILED] (HTTP {status}, Expected {expected_code})")
                return False, body
    except urllib.error.HTTPError as e:
        print(f"[FAILED] (HTTP {e.code})")
        return False, None
    except Exception as e:
        print(f"[ERROR] ({e})")
        return False, None

if __name__ == "__main__":
    host = sys.argv[1] if len(sys.argv) > 1 else "localhost"
    port = sys.argv[2] if len(sys.argv) > 2 else "80"
    base_url = f"http://{host}:{port}"

    print(f"==================================================")
    print(f" Running Smart Library API Test Suite against {base_url}")
    print(f"==================================================")

    s1, r1 = test_endpoint(f"{base_url}/")
    s2, r2 = test_endpoint(f"{base_url}/api/health")
    s3, r3 = test_endpoint(f"{base_url}/api/books")

    all_passed = s1 and s2 and s3
    print(f"==================================================")
    if all_passed:
        print("ALL API TESTS COMPLETED SUCCESSFULLY!")
        sys.exit(0)
    else:
        print("SOME TESTS FAILED.")
        sys.exit(1)
