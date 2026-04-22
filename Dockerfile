FROM frappe/erpnext:v16.15.0

USER root
RUN apt-get update && apt-get install -y curl gcc g++ make git && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs && npm install -g yarn && apt-get clean && rm -rf /var/lib/apt/lists/*

USER frappe
ENV NODE_OPTIONS="--max-old-space-size=8096"
RUN bench get-app --resolve-deps hrms --skip-assets && bench get-app --resolve-deps crm --skip-assets && bench get-app --resolve-deps helpdesk --skip-assets && bench build --app hrms && bench build --app crm && bench build --app helpdesk