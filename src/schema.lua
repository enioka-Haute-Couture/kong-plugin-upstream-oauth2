local typedefs = require "kong.db.schema.typedefs"

return {
  name = "upstream-oauth2",
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            token_url = {
              type = "string",
              required = true
            }
          },
          {
            client_id = {
              type = "string",
              required = true
            }
          },
          {
            client_secret = {
              type = "string",
              required = true
            }
          },
          {
            scope = {
              type = "string",
              required = false
            }
          },
        }
      }
    }
  }
}
