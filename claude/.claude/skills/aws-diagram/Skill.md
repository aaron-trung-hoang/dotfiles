---
name: AWS Diagram Generator
description: Generate professional AWS architecture diagrams using Python diagrams package. Use when user wants to create, draw, or visualize AWS infrastructure diagrams.
dependencies: python>=3.9, diagrams>=0.23
---

# AWS Architecture Diagram Generator

Generate professional AWS architecture diagrams using the Python `diagrams` package with best-practice layout techniques.

## When to Use This Skill

Activate this skill when the user:

- Wants to create an AWS architecture diagram
- Asks to visualize AWS infrastructure
- Needs to draw cloud architecture
- Mentions "diagram", "architecture diagram", or "infrastructure diagram" with AWS components

## Environment Setup

Before generating diagrams, ensure the environment is ready:

```bash
# Create virtual environment (if not exists)
python3 -m venv venv

# Install diagrams package
./venv/bin/pip install diagrams

# Install Graphviz (macOS)
brew install graphviz

# Run scripts with correct PATH (avoids alias conflicts)
PATH="/opt/homebrew/bin:$PATH" ./venv/bin/python <script>.py
```

## Best Practice Configuration

### Graph Attributes (Always Use)

```python
graph_attr = {
    "fontsize": "14",
    "bgcolor": "white",
    "pad": "1.0",
    "splines": "ortho",      # Clean orthogonal edges
    "nodesep": "1.0",        # Horizontal spacing
    "ranksep": "1.2",        # Vertical spacing
    "compound": "true",      # Enable cluster-to-cluster edges
}
```

### Subnet Color Styling

```python
public_attr = {"bgcolor": "#e6f3e6", "style": "dashed", "pencolor": "#52b788"}   # Green
private_attr = {"bgcolor": "#fff3e6", "style": "dashed", "pencolor": "#f4a261"}  # Orange
db_attr = {"bgcolor": "#e6e6f3", "style": "dashed", "pencolor": "#7678ed"}       # Blue
```

## Layout Techniques

### 1. Invisible Edges (Force Alignment)

```python
# Align non-connected nodes horizontally
alb >> Edge(style="invis") >> rds
```

### 2. Constraint False (Auxiliary Connections)

```python
# Prevent edge from affecting main layout
ecs >> Edge(label="logs", constraint="false") >> cloudwatch
```

### 3. Weight (Prioritize Main Flow)

```python
# Higher weight = straighter line
users >> Edge(label="HTTPS", weight="10") >> igw
```

### 4. Minlen (Control Spacing)

```python
# Minimum rank distance between nodes
ecs >> Edge(label="SSL", minlen="2") >> rds
```

## Standard Template

```python
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import ECS, EC2, Lambda, Fargate
from diagrams.aws.database import RDS, Aurora, Dynamodb, ElasticacheForRedis
from diagrams.aws.network import ALB, NLB, APIGateway, CloudFront, Route53, InternetGateway, NATGateway
from diagrams.aws.storage import S3, EFS
from diagrams.aws.security import IAM, SecretsManager, CertificateManager, WAF
from diagrams.aws.management import Cloudwatch, Cloudtrail
from diagrams.aws.integration import SQS, SNS, Eventbridge, StepFunctions
from diagrams.onprem.client import Users

graph_attr = {
    "fontsize": "14",
    "bgcolor": "white",
    "pad": "1.0",
    "splines": "ortho",
    "nodesep": "1.0",
    "ranksep": "1.2",
    "compound": "true",
}

public_attr = {"bgcolor": "#e6f3e6", "style": "dashed", "pencolor": "#52b788"}
private_attr = {"bgcolor": "#fff3e6", "style": "dashed", "pencolor": "#f4a261"}
db_attr = {"bgcolor": "#e6e6f3", "style": "dashed", "pencolor": "#7678ed"}

with Diagram(
    "AWS Architecture",
    show=False,
    direction="LR",
    graph_attr=graph_attr,
    filename="aws_architecture"
):
    # External
    users = Users("Users")

    with Cluster("Region"):
        igw = InternetGateway("Internet GW")

        with Cluster("VPC"):
            with Cluster("Public Subnet", graph_attr=public_attr):
                alb = ALB("ALB")

            with Cluster("Private Subnet", graph_attr=private_attr):
                ecs = ECS("ECS Service")

            with Cluster("DB Subnet", graph_attr=db_attr):
                rds = RDS("RDS")

            # Invisible edge for alignment
            alb >> Edge(style="invis") >> rds

    # Connections
    users >> Edge(label="HTTPS") >> igw >> Edge(label="HTTPS") >> alb
    alb >> Edge(label="HTTP") >> ecs
    ecs >> Edge(label="SSL") >> rds
```

## Common AWS Components

| Category | Components |
| -------- | ---------- |
| **Compute** | `EC2, ECS, EKS, Lambda, Fargate` |
| **Database** | `RDS, Aurora, Dynamodb, ElasticacheForRedis` |
| **Network** | `ALB, NLB, APIGateway, CloudFront, Route53, InternetGateway, NATGateway` |
| **Storage** | `S3, EFS, FSx` |
| **Security** | `IAM, SecretsManager, CertificateManager, WAF, Shield` |
| **Management** | `Cloudwatch, Cloudtrail, Config` |
| **Integration** | `SQS, SNS, Eventbridge, StepFunctions` |

## Common Architecture Patterns

### 3-Tier Web Application

```text
Users -> IGW -> ALB (Public) -> ECS (Private) -> RDS (DB)
                                     |
                                     +-> ElastiCache (Private)
```

### Serverless API

```text
Users -> API Gateway -> Lambda -> DynamoDB
              |
              +-> S3
```

### Microservices with Queue

```
Users -> ALB -> [Service1, Service2] -> SQS -> Lambda -> RDS
```

## Output Options

```python
# Single format (default: png)
with Diagram("Name", outformat="png"):

# Multiple formats
with Diagram("Name", outformat=["png", "svg", "pdf"]):

# Directions
direction="LR"  # Left to right (recommended)
direction="TB"  # Top to bottom
direction="RL"  # Right to left
direction="BT"  # Bottom to top
```

## Tips

1. Always use `direction="LR"` for horizontal AWS diagrams
2. Use `constraint="false"` for auxiliary services (logs, secrets, monitoring)
3. Use invisible edges to align subnet clusters horizontally
4. Group related nodes: `[node1, node2] >> target`
5. Use `-` for bidirectional connections: `node1 - node2`
6. Set `show=False` to prevent auto-opening; use `show=True` to preview immediately
