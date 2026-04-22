FROM frappe/erpnext:v16.15.0

# 1. Switch to root to install the missing build engines
USER root

# 2. Install Node.js, Yarn, and GCC 
# (GCC for Python dependencies, Node/Yarn for compiling the Vue frontends)
RUN apt-get update && \
    apt-get install -y curl gcc g++ make git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Switch back to the safe Frappe user
USER frappe

# 4. Fetch the apps (Now that the container has the tools to compile them)
RUN bench get-app --resolve-deps hrms && \
    bench get-app --resolve-deps crm && \
    bench get-app --resolve-deps helpdesk

# 5. Ensure all frontend assets are compiled into the final image
RUN bench build