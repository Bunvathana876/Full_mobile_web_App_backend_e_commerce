#!/usr/bin/env bash

# ==============================================================================
# E-Commerce Marketplace - One-Click Launcher
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}   Starting E-Commerce System (One-Click Setup)      ${NC}"
echo -e "${BLUE}======================================================${NC}"

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH.${NC}"
    echo "Please install Docker Desktop from https://www.docker.com/"
    exit 1
fi

# Build and start services in background
echo -e "\n${YELLOW}[1/3] Building and starting Docker containers...${NC}"
docker compose up --build -d

echo -e "\n${YELLOW}[2/3] Waiting for services to become healthy...${NC}"

# Wait for backend healthcheck
MAX_RETRIES=30
COUNT=0
until curl -s -f http://localhost:8000/health > /dev/null || [ $COUNT -eq $MAX_RETRIES ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo -n "."
done

echo ""

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}Warning: Backend is taking longer than expected to start.${NC}"
    echo "Check logs with: docker compose logs -f"
else
    echo -e "${GREEN}✓ All services (PostgreSQL, pgAdmin 4, Backend, Web App) are running and healthy!${NC}"
fi

echo -e "\n${BLUE}======================================================${NC}"
echo -e "${GREEN}   Services Available at:                            ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "  • Next.js Web App:      ${MAGENTA}http://localhost:3000${NC}"
echo -e "  • FastAPI API:          ${GREEN}http://localhost:8000${NC}"
echo -e "  • Interactive API Docs: ${GREEN}http://localhost:8000/docs${NC}"
echo -e "  • pgAdmin 4 Web UI:     ${CYAN}http://localhost:5050${NC}"
echo -e "      - Email:            ${YELLOW}admin@ecommerce.com${NC}"
echo -e "      - Password:         ${YELLOW}admin123${NC}"
echo -e "  • PostgreSQL Database:  ${GREEN}localhost:5433${NC}"
echo -e "      - Database:         ${YELLOW}ecommerce_db${NC}"
echo -e "      - Username:         ${YELLOW}ecommerce_user${NC}"
echo -e "      - Password:         ${YELLOW}GoPassword_123!${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "To view live logs:        ${YELLOW}docker compose logs -f${NC}"
echo -e "To stop all services:     ${YELLOW}docker compose down${NC}"
echo -e "To run Flutter mobile:    ${YELLOW}cd mobile-app && flutter run${NC}"
echo -e "${BLUE}======================================================${NC}"
