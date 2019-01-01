# Tool name   :Camera_RAW-JPG shell command
# Module name :OrgRAWJPG.sh
# Detail      :The script to organize RAW and JPG data automatically
# Implementer :R.Ishikawa
# Version     :1.0
# Last update :2019/1/1

# Version History
# 1. Create New                         R.Ishikawa  Ver.1.0  2019/1/1

echo ${0##*/} "is Running..."
# SETUP
cd `dirname $0`
JPG_EXT='JPG' #JPGの拡張子
DEFAULT_FROM_DIR='./'

echo "■Canonの場合・・・CR2"
echo "■Sony αの場合・・・ARW"
echo "■Nikonの場合・・・NEF"
echo "■Pentaxの場合・・・PEF"
echo "■Olympusの場合・・・ORF"
echo "■富士フィルムの場合・・・RAF"
echo "RAWの拡張子を入力してください"

read RAW_EXT

if [ -z ${RAW_EXT} ]; then
 echo "入力した拡張子は正しくありません"
 exit
fi
#if [ RAW_EXT =! "CR2" -o RAW_EXT != "ARW" -o RAW_EXT != "NEF" -o RAW_EXT != "PEF" ]; then
# echo "入力した拡張子は正しくありません"
# exit
#fi

# INIT
for OPT in "$@"
do
    if [ ${OPT} == '-dir' ]; then
       FLAG_DIR=1
       VALUE_DIR=$2
    fi
    shift
done

if [ "$FLAG_DIR" ]; then
    FROM_DIR=${VALUE_DIR}
else
    if [ "${DEFAULT_FROM_DIR}" ]; then
        FROM_DIR=${DEFAULT_FROM_DIR}
    else
        echo "[-dir 画像元ディレクトリの指定] が必要です"
        exit
    fi
fi


## ディレクトリの存在確認
if [ -d ${FROM_DIR}/${JPG_EXT} ]; then
echo "JPG ディレクトリが既に存在するためキャンセルしました"
exit
fi
if [ -d ${FROM_DIR}/${RAW_EXT} ]; then
echo "RAW ディレクトリが既に存在するためキャンセルしました"
exit
fi

## カウント
JPG_COUNT=0;RAW_COUNT=0
for jpg in $( ls ${FROM_DIR} | grep .${JPG_EXT}$ ); do
    $((++JPG_COUNT)) 2>/dev/null
done
for raw in $( ls ${FROM_DIR} | grep .${RAW_EXT}$ ); do
    $((++RAW_COUNT)) 2>/dev/null
done

echo "***JPG/RAWデータ検索結果***"
echo "FROM_DIR : ${FROM_DIR}"
echo "RAW : ${RAW_COUNT} 件"
echo "JPG : ${JPG_COUNT} 件"

## EXECUTE CONFIRM

echo "RAWをRAWディレクトリに、JPGをJPGディレクトリに移動しますか？ : y"
read CONFIRM

if [ ${CONFIRM} = y ]; then
  echo ""
else
  echo "キャンセルしました"
  exit
fi

## MKDIR
mkdir -p ${FROM_DIR}/${JPG_EXT} 2>/dev/null
mkdir -p ${FROM_DIR}/${RAW_EXT} 2>/dev/null

## 実行
for jpg in $( ls ${FROM_DIR} | grep .${JPG_EXT}$ ); do
    echo "moving... > "${jpg}
    mv -f ${FROM_DIR}/${jpg} ${FROM_DIR}/${JPG_EXT}
done
for raw in $( ls ${FROM_DIR} | grep .${RAW_EXT}$ ); do
    echo "moving... > "${raw}
    mv -f ${FROM_DIR}/${raw} ${FROM_DIR}/${RAW_EXT}
done

echo "Done."
