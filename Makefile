# Nom du programme
TARGET = gpiod

# Répertoires
INSTALL_DIR ?= ./.install
INIT_SCRIPT = esme-led

# Options de compilation et d'édition de liens
CFLAGS += $(shell pkg-config --cflags libgpiod)
LDLIBS += $(shell pkg-config --libs libgpiod)

# Liste des fichiers sources
SRC = gpio-toggle.c

# Cible par défaut
all: $(TARGET)

# Compilation implicite, en utilisant les règles intégrées de GNU Make
$(TARGET): $(SRC)

# Cible d'installation
install: $(TARGET)
	mkdir -p $(INSTALL_DIR)
	cp $(TARGET) $(INSTALL_DIR)
	@echo "Programme installé dans $(INSTALL_DIR)"
	sudo cp $(INIT_SCRIPT) /etc/init.d/
	sudo chmod 0755 /etc/init.d/$(INIT_SCRIPT)
	@echo "Script $(INIT_SCRIPT) installé dans /etc/init.d"

# Cible pour nettoyer les fichiers générés
clean:
	$(RM) $(TARGET) *.o
	@echo "Nettoyage effectué"