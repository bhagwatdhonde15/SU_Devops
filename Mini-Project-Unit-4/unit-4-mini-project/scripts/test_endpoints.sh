#!/usr/bin/env bash
# ==============================================================================
# Enterprise Smart Library Management Platform - API Verification Script
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

set -euo pipefail

TARGET_HOST="${1:-localhost}"
TARGET_PORT="${2:-80}"

BASE_URL="http://${TARGET_HOST}:${TARGET_PORT}"

echo "=========================================================="
echo " Testing Smart Library API at ${BASE_URL}"
echo "=========================================================="

echo ""
echo "--- 1. Testing Root Endpoint: curl ${BASE_URL}/ ---"
curl -s "${BASE_URL}/" | jq . || curl -s "${BASE_URL}/"

echo ""
echo "--- 2. Testing Health Endpoint: curl ${BASE_URL}/api/health ---"
curl -s "${BASE_URL}/api/health" | jq . || curl -s "${BASE_URL}/api/health"

echo ""
echo "--- 3. Testing Books Endpoint: curl ${BASE_URL}/api/books ---"
curl -s "${BASE_URL}/api/books" | jq . || curl -s "${BASE_URL}/api/books"

echo ""
echo "--- 4. Adding a New Book: POST ${BASE_URL}/api/books ---"
curl -s -X POST "${BASE_URL}/api/books" \
  -H "Content-Type: application/json" \
  -d '{"title": "Clean Architecture", "author": "Robert C. Martin"}' | jq . || true

echo ""
echo "--- 5. Verifying Books List After Insertion ---"
curl -s "${BASE_URL}/api/books" | jq . || curl -s "${BASE_URL}/api/books"

echo ""
echo "=========================================================="
echo " All API endpoint checks completed!"
echo "=========================================================="
