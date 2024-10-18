# laundry_mobile
## โครงสร้างโฟเดอร์ภายในแอพพลิเคชัน

- /lib/app  
# โฟลเดอร์เก็บส่วนของแอพพลิเคชัน 
    -/common
    # โฟเดอร์เก็บส่วนวิตเจ็ตที่สามารถนำกลับมาใช้ใหม่ได้
        -layout
        #โฟเดอร์เก็บการตั้งค่า custom layout ที่สามารถเรียกไปใช้ได้ทันที  ListView && GrideView
        -style
        #โฟเดอร์เก็บเก็บการตั้งค่าของ ธีม บางส่วนภายในแอพ
        -widgets
        #โฟเดอร์เก็บ Custom widgts ที่สามารถเรียกไปใช้ได้ตามความเหมาะสม

    - /data
    # โฟเดอร์เก็บทุกอย่างเกี่ยวกับข้อมูลและการติดต่อกับฐานข้อมูล
       -/models
        #โฟเดอร์เก็บโมเดลข้อมูลทั้งหมดภายในแอพพลิเคชัน
        -/repository
        #โฟเดอร์เก็บส่วนการติดต่อกับฐานข้อมูล
        -/service 
        #โฟเดอร์เก็บส่วนการต่อกับบริการภายนอก รูปาพ , MQTT ,Location
    -/modules
    # โฟเดอร์เก็บโมดูลของแอพพลิเคชัน ประกอบด้วย view controller
        -/authentication
        #โฟเดอร์เก็บโมดูลในส่วนของการ authentication ทั้งหมด
            -/controller
            #โฟเดอร์เก็บส่วนของการคอนโทรลเลอร์ของโมดูล authentication
            -/view
            #โฟเดอร์เก็บส่วนของสกีนหน้าต่างๆ ภายในโมดูล authentication
        -/shop
        #โฟเดอร์เก็บโมดูลในส่วนของการ shop ทั้งหมด
            -/controller
            #โฟเดอร์เก็บส่วนของการคอนโทรลเลอร์ของโมดูล shop
            -/view
            #โฟเดอร์เก็บส่วนของสกีนหน้าต่างๆ ภายในโมดูล shop


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
