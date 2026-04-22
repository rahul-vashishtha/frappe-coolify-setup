# Frappe + ERPNext + HRMS + CRM + Helpdesk on Coolify

Docker Compose setup for deploying a custom Frappe/ERPNext stack on Coolify with these apps baked into a single image:

- `erpnext`
- `hrms`
- `crm`
- `telephony`
- `helpdesk`

This repository builds the custom image locally on the Coolify server. It does not require publishing an image to Docker Hub or GHCR.

## Stack

- Base image: `frappe/erpnext:v16.15.0`
- Custom apps:
  - `hrms` from `version-16`
  - `crm` from `main`
  - `telephony` from `develop`
  - `helpdesk` from `main`
- Database: `mariadb:11.8`
- Redis:
  - `redis-cache`
  - `redis-queue`

## How It Works

`Dockerfile` builds a custom image on top of `frappe/erpnext:v16.15.0`, installs the extra apps, and runs `bench build`.

`docker-compose.yml` then:

- builds that image once in the `configurator` service
- reuses the same local image for all runtime services
- creates the site in the `create-site` one-shot job
- starts backend, websocket, workers, scheduler, and frontend only after site setup is complete

## Repository Files

- [Dockerfile](./Dockerfile)
- [docker-compose.yml](./docker-compose.yml)

## Required Environment Variables

Set these in Coolify for the stack:

- `SITE_NAME`
- `SERVICE_PASSWORD_ADMIN`
- `SERVICE_PASSWORD_DB`

Optional:

- `FRAPPE_IMAGE`
  Default: `frappe-custom:v16.15.0`

## Coolify Deployment

1. Create a new resource from this Git repository.
2. Choose `Docker Compose` as the build pack.
3. Point Coolify to `docker-compose.yml`.
4. Set the required environment variables:
   - `SITE_NAME`
   - `SERVICE_PASSWORD_ADMIN`
   - `SERVICE_PASSWORD_DB`
5. Deploy.

On first deploy, Coolify will:

- build the custom image from `Dockerfile`
- create the MariaDB and Redis services
- run `configurator`
- run `create-site`
- start the app services

## Important Customization

Before using this in your own project, update the Traefik router rule in [docker-compose.yml](./docker-compose.yml):

```yaml
- 'traefik.http.routers.frappe-router.rule=HostRegexp(`^.+\.igris\.studio$`) || HostRegexp(`^.+\.shopishvara\.com$`)'
```

Replace those domains with your own.

Also note:

- `FRAPPE_SITE_NAME_HEADER` is set to `${SITE_NAME}`
- the frontend service exposes `8081:8080`

## Persistent Volumes

This setup uses:

- `db-data-v3`
- `sites-v3`
- `logs-v3`
- `redis-queue-data`

If you need a completely clean reinstall, remove those volumes and redeploy.

## Site Creation Behavior

`create-site` is idempotent:

- if the site directory does not exist, it creates the site and installs the apps
- if the site already exists, it skips creation and runs `bench migrate`

## Notes

- This setup is designed for Coolify-managed Docker Compose deployment.
- The extra apps are baked into the image instead of being fetched at container startup.
- This avoids runtime drift between containers and keeps app code consistent across backend, workers, websocket, and frontend.

## License

See [LICENSE](./LICENSE).
