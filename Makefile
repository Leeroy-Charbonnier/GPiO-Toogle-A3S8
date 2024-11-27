# Répertoires
INSTALL_DIR ?= ./.install/

# Fichiers
PROG := gpio-toggle
SCRIPT = esme-led

# Fichiers objets
OBJS := $(subst .c,.o,$(shell ls *.c))

# Options de compilation et d'édition de liens
CFLAGS += $(shell pkg-config --cflags libgpiod)
LDLIBS += $(shell pkg-config --libs libgpiod)

# Cible par défaut
all: $(PROG)

$(PROG): $(OBJS)

# Cible d'installation
install: $(PROG) $(SCRIPT)
	# Créer le répertoire d'installation s'il n'existe pas
	mkdir -p $(INSTALL_DIR)/usr/bin
	# Copier le programme dans le répertoire d'installation
	cp $(PROG) $(INSTALL_DIR)/usr/bin
	@echo "$(PROG) installé dans $(INSTALL_DIR)/usr/bin"
	# Créer le répertoire d'installation s'il n'existe pas
	mkdir -p $(INSTALL_DIR)/etc/init.d
	# Copier le script esme-led dans /etc/init.d et ajuster les permissions
	cp $(SCRIPT) $(INSTALL_DIR)/etc/init.d/
	chmod 0755 $(INSTALL_DIR)/etc/init.d/$(SCRIPT)
	@echo "$(SCRIPT) installé dans $(INSTALL_DIR)/etc/init.d avec chmod 0755"

# Cible pour nettoyer les fichiers générés
clean:
	-$(RM) -rf $(PROG) $(OBJS)
	@echo "Nettoyage effectué"