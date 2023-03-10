DBASE	=	srcs/requirements/base
NBASE	=	inception-base

base:
	@make -C $(DBASE)
	@docker run --rm $(NBASE)
