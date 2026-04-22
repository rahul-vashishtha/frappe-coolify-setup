FROM frappe/erpnext:v16.15.0

USER root
RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*

USER frappe
RUN mkdir -p /home/frappe/frappe-bench/sites && printf '{\n  "socketio_port": 9000\n}\n' > /home/frappe/frappe-bench/sites/common_site_config.json

RUN bench get-app https://github.com/frappe/hrms --branch main --skip-assets
RUN bench get-app https://github.com/frappe/crm --branch main --skip-assets
RUN bench get-app https://github.com/frappe/telephony --branch main --skip-assets
RUN bench get-app https://github.com/frappe/helpdesk --branch main --skip-assets
