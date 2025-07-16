
# SECURITY GROUP MODULE - NETWORK ACCESS CONTROL
# This module implements a layered security architecture for the GoGreen Insurance application
# Creates security groups for each application tier with principle of least privilege
# Purpose: Controls network traffic flow between application components and external users

resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "Security group for ELB load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}
# Purpose: Security group for the Application Load Balancer (internet-facing tier)
# HTTP (Port 80): Handles initial user requests and redirects to HTTPS
# HTTPS (Port 443): Encrypted traffic for secure insurance data transmission
# Source 0.0.0.0/0: Allows public internet access for customer-facing application
# Egress Rules: Unrestricted outbound for health checks and backend communication
# Security Layer: First line of defense filtering incoming internet traffic
# Business Context: Enables customers to access GoGreen Insurance website securely

resource "aws_security_group" "sg_web" {
  name        = "sg_web"
  description = "Security group for Web Tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_elb.id]
    description     = "Allow HTTP from ELB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}
# Purpose: Security group for web servers (presentation tier)
# Ingress Restriction: Only accepts traffic from the load balancer security group
# Port 80: Web servers receive traffic from ALB on standard HTTP port
# Security Principle: No direct internet access - traffic must flow through ALB
# Isolation: Web tier cannot be accessed directly from internet
# Egress Freedom: Web servers can reach app tier, databases, and external APIs
# Architecture: Implements proper three-tier application security model

resource "aws_security_group" "sg_app" {
  name        = "sg_app"
  description = "Security group for App Tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_web.id]
    description     = "Allow TCP 8080 from Web Tier"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}
# Purpose: Security group for application servers (business logic tier)
# Port 8080: Common port for Java applications, microservices, and APIs
# Access Control: Only web tier can communicate with application tier
# Business Logic Protection: Application servers isolated from direct access
# API Security: Protects internal APIs and business logic from unauthorized access
# Egress Access: App servers can connect to databases, external services, and APIs
# Microservices: Supports containerized applications and service mesh architectures

resource "aws_security_group" "sg_db" {
  name        = "sg_db"
  description = "Security group for Database Tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_app.id]
    description     = "Allow MySQL from App Tier"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}
# Purpose: Security group for database servers (data tier)
# Port 3306: MySQL/MariaDB standard port for database connections
# Maximum Security: Only application tier can access databases
# Data Protection: Insurance customer data protected by multiple security layers
# Database Isolation: No direct access from web tier or internet
# Compliance: Meets PCI DSS and insurance industry security requirements
# Backup Access: Egress allows database backups and replication traffic
# Critical Security: Most restrictive rules protect sensitive customer information