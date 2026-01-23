# AWS Architecture Diagram Generator

Generate professional AWS architecture diagrams using the Python `diagrams` package.

## Instructions

When the user wants to create an AWS architecture diagram:

1. **Check/Setup Environment**:
   - Verify if `venv` exists, if not create it: `python3 -m venv venv`
   - Install diagrams if needed: `./venv/bin/pip install diagrams`
   - Ensure Graphviz is installed: `brew install graphviz` (macOS)
   - Always run scripts with: `PATH="/opt/homebrew/bin:$PATH" ./venv/bin/python <script>.py`

2. **Create the Diagram Script** using these best practices:

### Recommended Graph Attributes
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

### Subnet Styling (Colored Dashed Borders)
```python
public_attr = {"bgcolor": "#e6f3e6", "style": "dashed", "pencolor": "#52b788"}
private_attr = {"bgcolor": "#fff3e6", "style": "dashed", "pencolor": "#f4a261"}
db_attr = {"bgcolor": "#e6e6f3", "style": "dashed", "pencolor": "#7678ed"}
```

### Layout Techniques

| Technique | Usage | Purpose |
|-----------|-------|---------|
| `Edge(style="invis")` | `node1 >> Edge(style="invis") >> node2` | Force alignment between non-connected nodes |
| `constraint="false"` | `Edge(label="x", constraint="false")` | Prevent edge from affecting node positioning |
| `weight="10"` | `Edge(weight="10")` | Prioritize this path (keeps it straight) |
| `minlen="2"` | `Edge(minlen="2")` | Minimum rank distance between nodes |

### Standard Template
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

with Diagram(
    "Architecture Name",
    show=False,
    direction="LR",  # LR=left-to-right, TB=top-to-bottom
    graph_attr=graph_attr,
    filename="output_name"
):
    # Build diagram here
    pass
```

### Common Patterns

**3-Tier Web App:**
```
Users -> IGW -> ALB (Public) -> ECS (Private) -> RDS (DB Subnet)
                                     |
                                     +-> Redis (Private)
```

**Serverless API:**
```
Users -> API Gateway -> Lambda -> DynamoDB
              |
              +-> S3
```

**Microservices:**
```
Users -> CloudFront -> ALB -> [Service1, Service2, Service3] -> RDS
                                        |
                                        +-> SQS -> Lambda
```

## Output Formats
- `outformat="png"` (default)
- `outformat="svg"` (scalable)
- `outformat=["png", "svg", "pdf"]` (multiple)

## Tips
- Use `direction="LR"` for horizontal flow (recommended for AWS diagrams)
- Group related nodes: `[node1, node2] >> target` connects both to target
- Use `-` for bidirectional: `node1 - node2`
- Always use `constraint="false"` for auxiliary connections (logs, secrets, monitoring)
- Use invisible edges to align subnets horizontally: `public_alb >> Edge(style="invis") >> db_rds`

## Alternative Layouts
- **Osage** (grid): `graph_attr={"layout": "osage", "packmode": "array_u"}`
- **Neato** (organic): `graph_attr={"layout": "neato", "overlap": "false"}`

$ARGUMENTS
