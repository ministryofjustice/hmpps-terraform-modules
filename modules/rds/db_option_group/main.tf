resource "aws_db_option_group" "this" {
  count                    = var.create ? 1 : 0
  name_prefix              = var.name_prefix
  option_group_description = var.option_group_description == "" ? format("Option group for %s", var.identifier) : var.option_group_description
  engine_name              = var.engine_name
  major_engine_version     = var.major_engine_version
  #option                   = var.options

  #option {
  #  option_name = "Timezone"
  #
  #  option_settings {
  #    name  = "TIME_ZONE"
  #    value = "UTC"
  #  }
  #}

  dynamic "option" {
      
      for_each = var.options
    
      content {
        option_name = "${var.name_prefix}-${option.key}"

        option_settings {
          name  = option.key
          value = option.value
        }
      }
  }
      
  tags                     = merge(var.tags, map("Name", format("%s", var.identifier)))
}
