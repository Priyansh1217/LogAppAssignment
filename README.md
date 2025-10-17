# 📊 LogAppAssignment — CloudWatch Log & Dashboard Automation

This project demonstrates how to deploy a simple Python-based log generator on an AWS EC2 instance, configure the **CloudWatch Agent** to push logs and metrics to **Amazon CloudWatch**, and visualize them using a custom **CloudWatch Dashboard**.

---

## 🧱 **Architecture Overview**

```
┌────────────────────────┐
│      EC2 Instance      │
│  (Amazon Linux 2)      │
│                        │
│  • Python app logs →   │────┐
│  • CloudWatch Agent →  │    │
└────────────────────────┘    │
                              ▼
                    ┌──────────────────────┐
                    │  CloudWatch Logs     │
                    │  (LogAppGroup)       │
                    └──────────────────────┘
                              │
                              ▼
                    ┌──────────────────────┐
                    │  CloudWatch Metrics  │
                    │  CPU, Memory, Disk   │
                    └──────────────────────┘
                              │
                              ▼
                    ┌──────────────────────┐
                    │  Dashboard:          │
                    │  LogAppDashboard     │
                    └──────────────────────┘
```

---

## 🧰 **Project Structure**

```
LogAppAssignment/
│
├── app/
│   └── app.py                         # Python script that generates logs
│
├── scripts/
│   ├── setup-app.sh                   # Installs dependencies & starts app
│   └── setup-cloudwatch-agent.json    # CloudWatch Agent configuration
│
└── cloudwatch/
    └── dashboard.json                 # Custom CloudWatch Dashboard layout
```

---

## 🚀 **Setup Instructions**

### 1️⃣ **Launch an EC2 Instance**

- **AMI:** Amazon Linux 2  
- **Instance Type:** t2.micro (Free Tier)  
- **Security Group:**
  - Inbound: SSH (22), HTTP (80), HTTPS (443)
  - Outbound: All traffic
- Attach an **IAM Role** with:
  - `CloudWatchFullAccess`
  - `AmazonSSMManagedInstanceCore`

---

### 2️⃣ **Clone the Repository**

```bash
git clone https://github.com/<your-username>/LogAppAssignment.git
cd LogAppAssignment
```

---

### 3️⃣ **Run Setup Script**

```bash
chmod +x scripts/setup-app.sh
sudo ./scripts/setup-app.sh
```

This will:
- Install Python  
- Copy `app.py` to `/opt/logapp/`  
- Start the Python app in background  

You can verify:
```bash
sudo tail -f /opt/logapp/app.log
```

---

### 4️⃣ **Configure CloudWatch Agent**

Copy and activate configuration:

```bash
sudo cp scripts/setup-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl   -a fetch-config -m ec2   -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
```

Verify:
```bash
sudo systemctl status amazon-cloudwatch-agent
```

Check logs:
```bash
sudo tail -f /opt/aws/amazon-cloudwatch-agent/logs/agent.log
```

---

### 5️⃣ **Create CloudWatch Dashboard**

```bash
aws cloudwatch put-dashboard   --dashboard-name "LogAppDashboard"   --dashboard-body file://cloudwatch/dashboard.json
```

---

## 📊 **Dashboard Features**

| Widget | Description |
|--------|--------------|
| 🔍 Logs Viewer | Clickable link to open Logs Insights for `LogAppGroup` |
| 💻 CPU Utilization | EC2 CPU usage (AWS/EC2) |
| 🧠 Memory Usage | From CloudWatch Agent |
| 💾 Disk Usage | Root partition usage (/) |
| 🌐 Network I/O | Inbound & outbound traffic metrics |

---

## 🧠 **How It Works**

1. `app.py` continuously writes random log events to `/opt/logapp/app.log`.  
2. The **CloudWatch Agent** collects these logs and pushes them to **CloudWatch Logs** (`LogAppGroup`).  
3. The **Agent** also sends system metrics (CPU, memory, disk, network).  
4. The **Dashboard** visualizes this data in near real-time.

---

## 🧪 **Verification Steps**

### ✅ Logs
Go to:  
👉 **CloudWatch → Logs → Log groups → `/LogAppGroup`**  
You should see a stream like `i-xxxxxxxxxxxx-app.log`.

### ✅ Metrics
Go to:  
👉 **CloudWatch → Metrics → CWAgent / EC2**  
You’ll find memory, disk, and CPU graphs.

### ✅ Dashboard
Go to:  
👉 **CloudWatch → Dashboards → LogAppDashboard**

---

## ⚙️ **Troubleshooting**

| Issue | Fix |
|-------|-----|
| Logs not visible in CloudWatch | Check IAM Role and verify `/opt/aws/amazon-cloudwatch-agent/logs/agent.log` |
| Dashboard shows errors | Ensure `dashboard.json` syntax is valid JSON |
| Agent inactive | Restart with `sudo systemctl restart amazon-cloudwatch-agent` |
| Push error to GitHub | Use `git push origin main --force` if necessary |

---

## 👨‍💻 **Author**
**Priyansh Shah**  
AWS | Python | Cloud Automation  
📧 [your-email@example.com](mailto:your-email@example.com)

---

## 🧾 **License**
This project is licensed under the **MIT License** — feel free to use and modify it.
