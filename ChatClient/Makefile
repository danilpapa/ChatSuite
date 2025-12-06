.PHONY: check_empty generate generate_tuist

projects ?=

ifeq ($(projects),ALL)
    projects_option =
else
    projects_option = $(strip $(projects))
endif

generate: 
	@if [ -z "$${projects}" ] && [ -z "$${all_targets}" ]; then \
		./scripts/cli_generator.sh; \
	else \
		$(MAKE) project_generate; \
	fi
	

project_generate:
	@ tuist install || { echo "❌ Ошибка при tuist install"; exit 1; }
	@ tuist generate $(projects_option) || { echo "❌ Ошибка при tuist generate"; exit 1; }
	@ echo "✅ Генерация успешно завершена."
