FROM frappe/erpnext:v16.15.0

USER frappe

# 1. Use --resolve-deps to fix missing Python packages
# 2. Use --skip-assets (NOT --no-build) to skip heavy UI compiling during the fetch phase
RUN bench get-app --resolve-deps hrms --skip-assets && \
    bench get-app --resolve-deps crm --skip-assets && \
    bench get-app --resolve-deps helpdesk --skip-assets

# 3. Compile all the frontends together in one efficient sweep at the end
RUN bench build