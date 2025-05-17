FROM php:8.2-apache

# ติดตั้ง dependencies และ extensions ที่จำเป็น
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้ง PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    intl \
    mysqli \
    pdo_mysql \
    zip \
    gd \
    mbstring

# เปิดใช้งาน mod_rewrite สำหรับ .htaccess
RUN a2enmod rewrite

# ติดตั้ง Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# กำหนด workdir
WORKDIR /var/www/html

# กำหนดสิทธิ์ให้ Apache เขียนได้ในโฟลเดอร์ writable
RUN chown -R www-data:www-data /var/www/html

# กำหนด Apache Document Root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# ปรับแต่ง Apache config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# เพิ่ม PHP configuration สำหรับการพัฒนา
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "upload_max_filesize=100M" > /usr/local/etc/php/conf.d/upload-limit.ini \
    && echo "post_max_size=100M" >> /usr/local/etc/php/conf.d/upload-limit.ini \
    && echo "display_errors=1" > /usr/local/etc/php/conf.d/error-display.ini \
    && echo "error_reporting=E_ALL" >> /usr/local/etc/php/conf.d/error-display.ini

# Expose port 80
EXPOSE 80

# CMD ดีฟอลต์มาจาก php:apache image