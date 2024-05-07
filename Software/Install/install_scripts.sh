#!/bin/bash
#
HOMEDIR=$(dirname $0)/..
INSTALLDIR=/opt/AstrAlim

echo "Begin Installing scripts"
cat > /etc/profile.d/AstrAlim.sh << END
# Environnement Python AstrAlim 
export PYTHONPATH=\$PYTHONPATH:$INSTALLDIR
export PATH=\$PATH:$INSTALLDIR
END

echo "Install dependency"
sudo apt -y install python3 python3-libgpiod python3-smbus python3-pyqt5
sudo apt -y install gpiod i2c-tools 

# Installer les fichiers 
if [ -d  $INSTALLDIR ]
then
	rm -rf $INSTALLDIR
fi
mkdir -p $INSTALLDIR
for FILE in Astra*.py ina219.py syspwm.py bme280_lib.py
do
	cp ${HOMEDIR}/pythonDrivers/${FILE} $INSTALLDIR
done
chmod a+rx  $INSTALLDIR/Astra*.py
chmod og-w $INSTALLDIR/Astra*.py

STARTALLSCRIPT=$INSTALLDIR/AstraStartAllHmi.sh
LISTHMI="AstraGpioHmi.py AstraPwmHmi.py AstraInaHmi.py"
echo "#!/bin/bash" > $STARTALLSCRIPT
for FILE in $LISTHMI
do
	echo "$INSTALLDIR/$FILE &" >> $STARTALLSCRIPT
done
chmod a+rx $STARTALLSCRIPT
chmod og-w $STARTALLSCRIPT

echo "Begin Installing scripts"

