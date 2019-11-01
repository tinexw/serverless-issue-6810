Minimal example to reproduce https://github.com/serverless/serverless/issues/6810

Run `./script.sh`

It will
- Create an API gateway
- Deploy one HTTP endpoint `/bar`.
- Deploy another HTTP endpoint `/foo`.
- Deploy the first endpoint `/bar` again. **This is where the bug occurs** The endpoint is deleted.
- Deploy the first endpoint `/bar` yet again. This will create the endpoint again.
- Destroy everything

Note that the `restApiResources` property is generated dynamically by querying all available resources from the API gateway. Thus, the list will include the resource itself.
