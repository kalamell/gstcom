# CodeIgniter 4 Docker Development Environment

## การติดตั้ง

### กรณีโปรเจ็คใหม่ต้องสร้าง โฟลเดอร์แล้วย้ายไป
docker-compose exec app mkdir -p /var/www/codeigniter
docker-compose exec app composer create-project codeigniter4/appstarter /var/www/codeigniter

จากนั้นคัดลอกไฟล์ทั้งหมดกลับมาที่ /var/www/html:
docker-compose exec app cp -R /var/www/codeigniter/. /var/www/html/

### กรณีมีโฟลเดอร์โปรเจ็คอยู่แล้ว
1. สร้างโปรเจค CodeIgniter 4 ใหม่ หรือ clone โปรเจคที่มีอยู่แล้ว:

```bash
# สร้างโปรเจคใหม่
composer create-project codeigniter4/appstarter .

# หรือ clone โปรเจคที่มีอยู่แล้ว
git clone [your-repo-url] .
```

2. คัดลอกไฟล์ `env` เป็น `.env`:

```bash
cp env .env
```

3. แก้ไขการตั้งค่าฐานข้อมูลใน `.env`:

```
database.default.hostname = mysql
database.default.database = codeigniter4
database.default.username = codeigniter
database.default.password = secretpassword
database.default.DBDriver = MySQLi
```

4. สร้างและเริ่มต้นคอนเทนเนอร์:

```bash
docker-compose up -d
```

## การเข้าถึง

- เว็บแอปพลิเคชัน: http://localhost:8080
- phpMyAdmin: http://localhost:8081
  - ชื่อผู้ใช้: root
  - รหัสผ่าน: rootpassword

## คำสั่งที่มีประโยชน์

- เข้าไปยังคอนเทนเนอร์แอปพลิเคชัน:

```bash
docker-compose exec app bash
```

- รันคำสั่ง CLI ของ CodeIgniter:

```bash
docker-compose exec app php spark [command]
```

- ตรวจสอบ log:

```bash
docker-compose logs -f app
```

- หยุดคอนเทนเนอร์:

```bash
docker-compose down
```

- หยุดคอนเทนเนอร์และลบ volumes:

```bash
docker-compose down -v
```

## การแก้ไขปัญหา

1. หากมีปัญหาเกี่ยวกับสิทธิ์ในการเขียนไฟล์:

```bash
docker-compose exec app chown -R www-data:www-data /var/www/html
```

2. หากต้องการเปลี่ยนแปลงรหัสผ่านฐานข้อมูล ให้แก้ไขไฟล์ `docker-compose.yml` และสร้างคอนเทนเนอร์ใหม่

3. ตรวจสอบให้แน่ใจว่าโฟลเดอร์ `writable` ในโปรเจค CodeIgniter มีสิทธิ์ในการเขียน:

```bash
docker-compose exec app chmod -R 777 /var/www/html/writable
```