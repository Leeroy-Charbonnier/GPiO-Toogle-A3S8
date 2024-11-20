#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#define GPIO_CHIP "/dev/gpiochip0" // Chemin du contrôleur GPIO
#define GPIO_PIN 17               // Numéro de la GPIO à utiliser
#define TOGGLE_INTERVAL 1         // Intervalle de basculement (en secondes)

int main() {
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int value = 0; // Initialisation de la valeur (0 : éteint, 1 : allumé)

    // Ouvrir le contrôleur GPIO
    chip = gpiod_chip_open(GPIO_CHIP);
    if (!chip) {
        perror("Erreur : Impossible d'ouvrir le contrôleur GPIO");
        return 1;
    }

    // Obtenir la ligne GPIO
    line = gpiod_chip_get_line(chip, GPIO_PIN);
    if (!line) {
        perror("Erreur : Impossible d'obtenir la ligne GPIO");
        gpiod_chip_close(chip);
        return 1;
    }

    // Configurer la ligne GPIO en sortie
    if (gpiod_line_request_output(line, "gpio-toggle", 0) < 0) {
        perror("Erreur : Impossible de configurer la ligne GPIO en sortie");
        gpiod_chip_close(chip);
        return 1;
    }

    printf("Contrôle de la LED sur GPIO#%d (Ctrl+C pour arrêter)\n", GPIO_PIN);

    // Boucle infinie pour basculer l'état de la LED
    while (1) {
        value = !value; // Inverser la valeur (0 -> 1 ou 1 -> 0)
        if (gpiod_line_set_value(line, value) < 0) {
            perror("Erreur : Impossible de modifier la valeur GPIO");
            break;
        }
        printf("GPIO#%d est maintenant : %s\n", GPIO_PIN, value ? "ALLUMÉE" : "ÉTEINTE");
        sleep(TOGGLE_INTERVAL);
    }

    // Libérer les ressources
    gpiod_line_release(line);
    gpiod_chip_close(chip);

    return 0;
}