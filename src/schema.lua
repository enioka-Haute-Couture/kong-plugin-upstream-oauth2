-- SPDX-FileCopyrightText: 2020 Henri Chain <henri.chain@enioka.com>
--
-- SPDX-License-Identifier: Apache-2.0

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
