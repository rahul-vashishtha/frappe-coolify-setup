FROM frappe/erpnext:v16.15.0

# Switch to the frappe user to run commands safely
USER frappe

# Download the apps and resolve their dependencies
RUN bench get-app hrms && \
    bench get-app crm && \
    bench get-app helpdesk