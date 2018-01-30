for i in {99..99};
do
  rm -rf /home/tenant${i}/.ssh
  mkdir -p /home/tenant${i}/.ssh
  chmod 700 /home/tenant${i}/.ssh
  cp ~/.ssh/id_rsa* /home/tenant${i}/.ssh/
  cp ~/.ssh/config /home/tenant${i}/.ssh/ -f
  chown -R tenant${i}:tenant${i} /home/tenant${i}/.ssh
done
