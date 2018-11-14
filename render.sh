DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

OUTPUTBASE=$DIR/rendered/

#aws
mkdir -p $OUTPUTBASE/aws/domain/
underware render $DIR/orchestration/aws/domain.yaml > $OUTPUTBASE/aws/domain/orchestration.yaml
nodeattr -n all | while read NODE; do
  mkdir -p $OUTPUTBASE/aws/$NODE/
  underware render $DIR/orchestration/aws/machine.yaml > $OUTPUTBASE/aws/$NODE/orchestration.yaml $NODE
  cd $DIR
  find deployment/ | while read f; do 
    if [ -f $f ]; then 
      mkdir -p $OUTPUTBASE/aws/$NODE/`dirname $f`
      underware render $DIR/$f > $OUTPUTBASE/aws/$NODE/$f $NODE
    fi 
  done
done
