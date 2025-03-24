# NAS

## Fan control

### Fan 1

Current rotation
```sh
cat /sys/class/hwmon/hwmon2/fan1_input
```

# enable manual mode for fan1: (if present for your hardware)
1 means manual, 2 auto

cat /sys/class/hwmon/hwmon2/pwm1_enable

echo 1 | sudo tee /sys/class/hwmon/hwmon2/pwm1_enable

echo 30 | sudo tee /sys/class/hwmon/hwmon2/pwm1


### Fan 2

cat /sys/class/hwmon/hwmon2/fan2_input

cat /sys/class/hwmon/hwmon2/pwm3_enable

echo 1 | sudo tee /sys/class/hwmon/hwmon2/pwm3_enable

echo 30 | sudo tee /sys/class/hwmon/hwmon2/pwm3
