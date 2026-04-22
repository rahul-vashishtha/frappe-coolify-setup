FROM frappe/erpnext:v16.15.0

USER root
RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*

USER frappe

RUN bench get-app https://github.com/frappe/hrms --branch main
RUN bench get-app https://github.com/frappe/crm --branch main
RUN bench get-app https://github.com/frappe/telephony --branch main
RUN bench get-app https://github.com/frappe/helpdesk --branch main
