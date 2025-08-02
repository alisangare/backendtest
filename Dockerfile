# Utiliser une image PHP avec Apache
FROM php:8.2-apache

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip pdo pdo_mysql

# Activer Apache Rewrite
RUN a2enmod rewrite

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de dépendances
COPY composer.json composer.lock ./

# Installer les dépendances PHP
RUN composer install --no-dev --no-scripts --no-autoloader --ignore-platform-reqs

# Copier le reste des fichiers
COPY . .

# Générer l'autoloader
RUN composer dump-autoload --optimize

# Configurer les permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port 80 (Apache)
EXPOSE 8000

# Démarrer Apache
CMD ["apache2-foreground"]