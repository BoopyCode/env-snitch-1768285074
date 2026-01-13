#!/bin/bash
# ENV Snitch - The tattletale for your environment variables
# Because secrets shouldn't have secret identities

# Colors for dramatic effect (like a detective's mood lighting)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (the boring kind)

# The snitching begins...
echo -e "${YELLOW}🔍 ENV Snitch is on the case!${NC}"
echo -e "${YELLOW}Ratting out your environment variables...${NC}\n"

# Check if we have a suspect file
if [ -f ".env" ]; then
    echo -e "${GREEN}Found .env file! Let's see what secrets it's hiding...${NC}"
    
    # Read .env file, ignoring comments and empty lines
    while IFS='=' read -r key value || [ -n "$key" ]; do
        # Skip comments and empty lines
        [[ $key =~ ^#.*$ ]] || [[ -z $key ]] && continue
        
        # Trim whitespace (because spaces are sneaky)
        key=$(echo "$key" | xargs)
        
        # Check if variable exists in environment
        if [ -n "${!key}" ]; then
            env_value="${!key}"
            
            # Compare values (the dramatic reveal!)
            if [ "$value" != "$env_value" ]; then
                echo -e "${RED}🚨 SNITCH ALERT! ${key} is different!${NC}"
                echo "  .env says:    $value"
                echo "  Environment:  $env_value"
                echo ""
            else
                echo -e "${GREEN}✓ ${key} matches${NC}"
            fi
        else
            echo -e "${YELLOW}⚠  ${key} exists in .env but not in environment${NC}"
        fi
    done < ".env"
else
    echo -e "${YELLOW}No .env file found. Checking all environment variables...${NC}"
    echo "(This might take a while. Get some coffee.)"
    echo ""
    
    # Just list all env vars if no .env file
    printenv | sort
fi

echo -e "\n${YELLOW}Case closed!${NC}"
echo "Remember: If it works on your machine, it's probably lying."