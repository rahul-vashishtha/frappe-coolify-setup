FROM frappe/erpnext:v16.15.0

USER frappe

# 1. Use --resolve-deps to fix missing Python packages
# 2. Use --no-build to skip the heavy Vite/Vue compiling during the fetch phase
RUN bench get-app hrms && \
    bench get-app --resolve-deps crm && \
    bench get-app --resolve-deps helpdesk