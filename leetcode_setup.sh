#!/bin/bash
#
# Description:
# Given the URL for a LeetCode problem, create all associated files.
#
# Usage: leetcode_setup.sh <leetcode-url>
#
# Examples:
#   leetcode_setup.sh https://leetcode.com/problems/two-sum

# Check if a URL is provided
if [ $# -eq 0 ]; then
    echo "Usage: ${0} <leetcode-url>"
    exit 1
fi

# Extract the problem name from the URL
url=${1}
problem_part=$(echo "${url}" | sed -E 's/.*problems\/([^\/]+).*/\1/')

# Convert to snake case for Python files
snake_case=$(echo "${problem_part}" | sed 's/-/_/g')

# Get the problem title (converting from kebab-case to Title Case)
title=$(echo "${problem_part}" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')

# Create the Python source file
cat > "../leetcode/src/${snake_case}.py" << EOF
"""
${title}

${url}
"""
EOF

# Create the test file
cat > "../leetcode/tests/test_${snake_case}.py" << EOF
"""
${title}

${url}
"""
EOF

# Append to the README.md file
echo -e "\n[${title}](./src/${snake_case}.py)" >> ../leetcode/README.md

# Create the Markdown file for the website
cat > "../grind-rip-site/site/content/leetcode/${snake_case}.md" << EOF
+++
title = '${title}'
slug = '${problem_part}'
draft = false
description =  '''
'''
+++

{{< include-code "content/leetcode/_leetcode/src/${snake_case}.py" "python" >}}
[Source](https://github.com/grind-rip/leetcode/blob/master/src/${snake_case}.py) | [LeetCode](${url})
EOF

echo "Setup completed for problem: ${title}"
