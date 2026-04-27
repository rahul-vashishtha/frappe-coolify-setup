FROM frappe/erpnext:v16.15.1

USER frappe
WORKDIR /home/frappe/frappe-bench

ARG HRMS_REF=version-16
ARG CRM_REF=main
ARG TELEPHONY_REF=develop
ARG HELPDESK_REF=main
ARG INDIA_COMPLIANCE_REF=version-16
ARG ECOMMERCE_INTEGRATIONS_REF=main

RUN mkdir -p sites \
    && printf '{\n  "socketio_port": 9000\n}\n' > sites/common_site_config.json \
    && printf 'frappe\nerpnext\n' > sites/apps.txt

RUN /home/frappe/frappe-bench/env/bin/pip install --no-cache-dir legacy-cgi==2.6.4 \
    && /home/frappe/frappe-bench/env/bin/python -c "import cgi"

RUN bench get-app https://github.com/frappe/hrms --branch ${HRMS_REF} --skip-assets
RUN bench get-app https://github.com/frappe/crm --branch ${CRM_REF} --skip-assets
RUN bench get-app https://github.com/frappe/telephony --branch ${TELEPHONY_REF} --skip-assets
RUN bench get-app https://github.com/frappe/helpdesk --branch ${HELPDESK_REF} --skip-assets
RUN bench get-app https://github.com/resilient-tech/india-compliance.git --branch ${INDIA_COMPLIANCE_REF}
RUN bench get-app https://github.com/frappe/ecommerce_integrations.git --branch ${ECOMMERCE_INTEGRATIONS_REF}

RUN /home/frappe/frappe-bench/env/bin/python -c "import cgi; import ecommerce_integrations.shopify.doctype.shopify_setting.shopify_setting"

RUN ls -1 apps > sites/apps.txt \
    && bench build --apps hrms,crm,telephony,helpdesk,india_compliance,ecommerce_integrations
