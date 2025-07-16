#!/bin/bash
# Generic Web Server Bootstrap Script
# This script configures a basic web server when EC2 instances launch

# Update the system
yum update -y

# Install Apache web server and AWS CLI
yum install -y httpd aws-cli

# Install PHP for dynamic content
yum install -y php php-mysql php-gd php-mbstring

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple health check endpoint
cat > /var/www/html/health.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Health Check</title>
</head>
<body>
    <h1>Server Status: OK</h1>
    <p>Web Server is running</p>
</body>
</html>
EOF

# Also create a plain text health endpoint that ALB prefers
echo "OK" > /var/www/html/health

# Create a basic homepage template
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Your Cloud Infrastructure</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            color: #333;
            border-bottom: 2px solid #007acc;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #007acc;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
            color: #666;
        }
        .server-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Cloud Infrastructure Demo</h1>
            <h2>Your AWS Infrastructure is Running Successfully</h2>
            <p>This is a template website hosted on your cloud infrastructure</p>
        </div>

        <div class="server-info">
            <h3>📊 Server Information</h3>
            <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
            <p><strong>Region:</strong> <span id="region">Loading...</span></p>
            <p><strong>Availability Zone:</strong> <span id="az">Loading...</span></p>
            <p><strong>Web Server:</strong> Apache HTTP Server</p>
            <p><strong>PHP Version:</strong> <?php echo phpversion(); ?> (if PHP is working)</p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>� Load Balancer</h3>
                <p>This server is behind an Application Load Balancer for high availability and traffic distribution.</p>
            </div>
            <div class="info-card">
                <h3>� Security</h3>
                <p>Server is in a private subnet with security groups controlling access. Only accessible through the load balancer.</p>
            </div>
            <div class="info-card">
                <h3>� Storage</h3>
                <p>Encrypted EBS volumes and secure S3 bucket storage with IAM role-based access.</p>
            </div>
            <div class="info-card">
                <h3>📈 Monitoring</h3>
                <p>CloudWatch monitoring enabled for metrics, logs, and health checks.</p>
            </div>
        </div>

        <div style="text-align: center; margin: 30px 0;">
            <h3>🛠️ Infrastructure Features</h3>
            <ul style="text-align: left; max-width: 600px; margin: 0 auto;">
                <li>✅ Multi-AZ VPC with public and private subnets</li>
                <li>✅ Application Load Balancer with health checks</li>
                <li>✅ Auto Scaling Group for high availability</li>
                <li>✅ IAM roles and policies for secure access</li>
                <li>✅ Encrypted storage (EBS and S3)</li>
                <li>✅ CloudWatch monitoring and logging</li>
                <li>✅ Security groups for network protection</li>
            </ul>
        </div>

        <div style="text-align: center; background: #007acc; color: white; padding: 20px; border-radius: 8px;">
            <h3>🎯 Customize This Website</h3>
            <p>Edit the files in /var/www/html/ to customize this website for your needs</p>
            <p>Or deploy your own application using this infrastructure as a foundation</p>
        </div>

        <div class="footer">
            <p>Powered by AWS Cloud Infrastructure</p>
            <p>Built with Terraform Infrastructure as Code</p>
        </div>
    </div>

    <script>
        // Fetch instance metadata using AWS instance metadata service
        fetch('/instance-info.php')
            .then(response => response.json())
            .then(data => {
                document.getElementById('instance-id').textContent = data.instanceId || 'Unable to fetch';
                document.getElementById('region').textContent = data.region || 'Unable to fetch';
                document.getElementById('az').textContent = data.availabilityZone || 'Unable to fetch';
            })
            .catch(error => {
                console.log('Metadata fetch failed:', error);
                document.getElementById('instance-id').textContent = 'Metadata unavailable';
                document.getElementById('region').textContent = 'Metadata unavailable';
                document.getElementById('az').textContent = 'Metadata unavailable';
            });
    </script>
</body>
</html>
EOF

# Configure AWS CLI region for S3 access
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
aws configure set region $REGION

# Create a PHP script to fetch instance metadata
cat > /var/www/html/instance-info.php << 'EOF'
<?php
header('Content-Type: application/json');

function getMetadata($path) {
    $url = "http://169.254.169.254/latest/meta-data/" . $path;
    $context = stream_context_create(['http' => ['timeout' => 2]]);
    return @file_get_contents($url, false, $context);
}

$data = [
    'instanceId' => getMetadata('instance-id'),
    'region' => getMetadata('placement/region'),
    'availabilityZone' => getMetadata('placement/availability-zone'),
    'instanceType' => getMetadata('instance-type'),
    'privateIp' => getMetadata('local-ipv4'),
    'publicIp' => getMetadata('public-ipv4')
];

echo json_encode($data);
?>
EOF

# Create a simple file upload demonstration
cat > /var/www/html/upload.php << 'EOF'
<?php
// Simple file upload demonstration
// This would typically integrate with your S3 bucket

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['document'])) {
    $uploadDir = '/tmp/uploads/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }
    
    $fileName = basename($_FILES['document']['name']);
    $uploadFile = $uploadDir . $fileName;
    
    if (move_uploaded_file($_FILES['document']['tmp_name'], $uploadFile)) {
        echo "<p>File uploaded successfully: $fileName</p>";
        echo "<p>In production, this would be uploaded to your S3 bucket.</p>";
    } else {
        echo "<p>Upload failed. Please try again.</p>";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>File Upload Demo</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
        .header { color: #333; text-align: center; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📁 File Upload Demo</h2>
            <h3>S3 Integration Example</h3>
        </div>
        
        <form method="POST" enctype="multipart/form-data">
            <p>Upload a file to test the functionality:</p>
            <input type="file" name="document" required>
            <br><br>
            <input type="submit" value="Upload File" style="background: #007acc; color: white; padding: 10px 20px; border: none; border-radius: 5px;">
        </form>
        
        <p><a href="index.html">← Back to Homepage</a></p>
    </div>
</body>
</html>
EOF

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 644 /var/www/html
chmod 755 /var/www/html

# Create uploads directory
mkdir -p /tmp/uploads
chown apache:apache /tmp/uploads

# Configure firewall for HTTP traffic
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Install CloudWatch agent for monitoring
yum install -y amazon-cloudwatch-agent

# Create CloudWatch agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "metrics": {
        "namespace": "CloudInfra/WebServers",
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_iowait", "cpu_usage_user", "cpu_usage_system"],
                "metrics_collection_interval": 60
            },
            "disk": {
                "measurement": ["used_percent"],
                "metrics_collection_interval": 60,
                "resources": ["*"]
            },
            "mem": {
                "measurement": ["mem_used_percent"],
                "metrics_collection_interval": 60
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/httpd/access_log",
                        "log_group_name": "/aws/ec2/webservers/apache-access",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "/aws/ec2/webservers/apache-error",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# Log the completion
echo "$(date): Generic web server setup completed" >> /var/log/user-data.log

# Restart Apache to ensure everything is working
systemctl restart httpd

echo "Web Server is ready to serve content!"
