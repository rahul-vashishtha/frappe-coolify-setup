FROM frappe/erpnext:v16.15.0

USER frappe

# 1. Use --resolve-deps to fix missing Python packages
# 2. Use --no-build to skip the heavy Vite/Vue compiling during the fetch phase
RUN bench get-app --resolve-deps hrms --no-build && \
    bench get-app --resolve-deps crm --no-build && \
    bench get-app --resolve-deps helpdesk --no-build

# 3. Compile all the frontends together in one efficient sweep at the end
RUN bench build