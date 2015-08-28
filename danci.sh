#!/bin/bash

###http://danci.daydayup.info/
book_list="l_6/l_4 l_6/l_6 toefl/gre toefl/ielts news/news tech/med" 
danci_list_url_base="http://danci.daydayup.info/book"
word_info_url_base="http://danci.daydayup.info/nw"

BASE="$(cd $(dirname $0); pwd)"
d_data="${BASE}/data"

mkdir -p ${d_data}
function get_danci_list(){
    for book in ${book_list}; do
        #echo "http://danci.daydayup.info/book?book=l_6/l_6&ID=test101"
        local book_danci_list_url="${danci_list_url_base}?book=${book}&ID=test101"
        local f_list="${d_data}/danci_$(echo ${book}|tr '/' '_').list"
        echo "${book_danci_list_url}"
        curl "${book_danci_list_url}">"${f_list}"
    done
}

function get_danci_json(){
    local book="${1}"
    if [ -z "${book}" ]; then
        echo "Please specify one book to read"
        return
    fi
    local f_list="${d_data}/danci_$(echo ${book}|tr '/' '_').list"
    local d_book="${d_data}/book_$(echo ${book}|tr '/' '_')"
    mkdir -p "${d_book}"
    while read word; do
        #http://danci.daydayup.info/nw?ID=test101&book=l_6/l_4&w=5&word=actual&lg=zh"
        local word_info_url="${word_info_url_base}?ID=test101&book=${book}&w=5&word=${word}&lg=zh"
        echo "${word_info_url}"
        curl "${word_info_url}" >"/tmp/response"
        ${BASE}/converter "/tmp/response" >"${d_book}/${word}.json"
        if [ $? -ne 0 ]; then
            echo "Failed to convert response to josn for word: ${book} ${word}!"
            exit 1
        fi

        ##local voa_uk_1=$(${BASE}/jq '.voa.uk[0]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
        #local voa_us_1=$(${BASE}/jq '.voa.us[0]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
#        local voa_uk_2=$(${BASE}/jq '.voa.uk[1]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
#        local voa_us_2=$(${BASE}/jq '.voa.us[1]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
        local voa_rp_1=$(${BASE}/jq '.voa.rp[0]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
        local voa_sc_1=$(${BASE}/jq '.voa.sc[0]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')
        local voa_gali_1=$(${BASE}/jq '.voa.gali[0]' "${d_book}/${word}.json" |sed 's/^"//'|sed 's/"$//')

        local voa_uk_1="http://dict.youdao.com/dictvoice?audio=${word}&type=1"
        if [ -n "${voa_uk_1}" ] && [ "X${voa_uk_1}" != "Xnull" ]; then
            curl "${voa_uk_1}" >"${d_book}/${word}-uk-1.mp3"
            if [ $? -ne 0 ]; then
                echo "Failed to get ${voa_uk_1}"
                exit 1
            fi
        fi

        local voa_us_1="http://dict.youdao.com/dictvoice?audio=${word}&type=2"
        if [ -n "${voa_us_1}" ] && [ "X${voa_us_1}" != "Xnull" ]; then
            curl "${voa_us_1}" >"${d_book}/${word}-us-1.mp3"
            if [ $? -ne 0 ]; then
                echo "Failed to get ${voa_us_1}"
                exit 1
            fi
        fi
#        if [ -n "${voa_uk_2}" ] && [ "X${voa_uk_2}" != "Xnull" ]; then
#            curl "${voa_uk_2}" >"${d_book}/${word}-uk-2.mp3"
#        fi
#        if [ -n "${voa_us_2}" ] && [ "X${voa_us_2}" != "Xnull" ]; then
#            curl "${voa_us_2}" >"${d_book}/${word}-us-2.mp3"
#        fi
#        if [ -n "${voa_rp_1}" ] && [ "X${voa_rp_1}" != "Xnull" ]; then
#            curl "${voa_rp_1}" >"${d_book}/${word}-rp-1.mp3"
#        fi
#        if [ -n "${voa_sc_1}" ] && [ "X${voa_sc_1}" != "Xnull" ]; then
#            curl "${voa_sc_1}" >"${d_book}/${word}-sc-1.mp3"
#        fi
#        if [ -n "${voa_gali_1}" ] && [ "X${voa_gali_1}" != "Xnull" ]; then
#            curl "${voa_gali_1}" >"${d_book}/${word}-gali-1.mp3"
#        fi

    done < "${f_list}"
}

#get_danci_list
for book in ${book_list}; do
    get_danci_json "${book}"
done
