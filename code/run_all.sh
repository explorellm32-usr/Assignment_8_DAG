#!/bin/bash

# Ensure we are in the correct directory
cd "$(dirname "$0")"

echo "=================================================="
echo "🧹 Clearing memory cache to ensure clean DAG runs"
echo "=================================================="
rm -f state/index.faiss state/index_ids.json state/memory.json

echo ""
echo "=================================================="
echo "▶️  PART 1: BASE QUERIES (hello, A, I, J, K)"
echo "=================================================="

echo "Running Query: hello"
uv run python flow.py "hello"
echo ""

echo "Running Query A: Fetch and distill Wikipedia"
uv run python flow.py "Fetch https://en.wikipedia.org/wiki/Claude_Shannon and tell me his birth date, death date, and three key contributions to information theory."
echo ""

echo "Running Query I: Extract populations"
uv run python flow.py "Find the populations of London, Paris, and Berlin and tell me which two are closest in size"
echo ""

echo "Running Query J: Graceful Fail on bad paths"
uv run python flow.py "Read /nonexistent/path.txt and tell me what's in it."
echo ""

echo "Running Query K: Extract growth rates"
uv run python flow.py "For Lagos, Cairo, and Kinshasa, find current populations and growth rates and tell me which is growing fastest."
echo ""

echo "=================================================="
echo "▶️  PART 2: PARALLEL FAN-OUT"
echo "=================================================="
echo "Running Query P: Weather comparison"
uv run python flow.py "Find the weather in Tokyo, London, and New York right now and tell me which is coldest."
echo ""

echo "=================================================="
echo "▶️  PART 3: CRITIC VERDICT & RECOVERY SPLICING"
echo "=================================================="
echo "Running Query C1: Test Critic - Unsupported Claims / Fabrication"
uv run python flow.py "Fetch the Wikipedia page for Paris and extract its population using the distiller. IMPORTANT: To test the critic, the distiller must deliberately output that the population is '999 Billion' on its first try. The critic will catch this fabrication because it contradicts the input text. On the recovery attempt, extract the correct population."
echo ""

echo "Running Query C2: Test Critic - Missing Required Fields"
uv run python flow.py "Research the birth years of Einstein, Newton, and Galileo. Instruct the distiller to extract all three, but deliberately OMIT Galileo entirely from its JSON output on the first try. The critic should fail it for missing fields. Upon recovery, extract all three correctly."
echo ""

echo "Running Query C3: Test Critic - Format Constraint Violation (Planner-inserted Critic)"
uv run python flow.py "Write a summary of the theory of relativity. The summary MUST be exactly 3 words long. To test the critic, deliberately write a 10-word summary on the first attempt so the critic fails it for violating the strict format constraint. Upon recovery, output exactly 3 words."
echo ""

echo "=================================================="
echo "▶️  PART 4: CODER SKILL & SANDBOX EXECUTOR"
echo "=================================================="
echo "Running Query Comp: Fibonacci Calculation"
uv run python flow.py "Calculate the 100th Fibonacci number and print it."
echo ""

echo "=================================================="
echo "▶️  PART 5: NEW CUSTOM SKILL (TRANSLATOR)"
echo "=================================================="
echo "Running Query T: French Translation"
uv run python flow.py "Translate the following sentence to French using the translator skill: 'Hello world, the multi-agent system is working perfectly!'"
echo ""

echo "🎉 All queries have been executed! Check the terminal output above for your demo."
