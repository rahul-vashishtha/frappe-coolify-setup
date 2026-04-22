FROM frappe/erpnext:v16.15.0

USER root
RUN apt-get update && apt-get install -y curl gcc g++ make git && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs && npm install -g yarn && apt-get clean && rm -rf /var/lib/apt/lists/*

USER frappe

RUN bench get-app hrms
RUN bench get-app --resolve-deps crm
RUN bench get-app --resolve-deps helpdesk