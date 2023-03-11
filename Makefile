HOSTNAME	=	/etc/hosts
HOSTALIAS	=	127.0.0.1 tgrivel.42.fr

hostname:
	grep "$(HOSTALIAS)" "$(HOSTNAME)" || echo "$(HOSTALIAS)" >> "$(HOSTNAME)"
