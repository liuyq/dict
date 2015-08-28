#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <wchar.h>
#include <string.h>

#define ARY_SIZE 64
/*
gcc -std=c99 -g  -rdynamic converter.c -o converter && ./converter /tmp/response
*/
int main(int argc,char *argv[ ]){
    setlocale(LC_ALL, "en_US.UTF-8");
    //setlocale(LC_ALL, "zh_CN.UTF-8");

    if(argc != 2){
        printf("please specify the input file.\n");
        printf("The input should be the output of url like this:\n");
        printf("\thttp://danci.daydayup.info/nw?ID=test101&book=l_6/l_4&w=5&word=actual&lg=zh\n");
        return(1);
    }

    //char * filePath = "/tmp/response";
    char * filePath = argv[1];
    FILE *fpIn;
    if ((fpIn = fopen(filePath, "r")) == NULL){
        printf("Failed to open the file: %s\n", filePath);
        return(1);
    }
    wint_t wc;
    int w_len = 0;
    while((wc=fgetwc(fpIn))!=WEOF){
        w_len++;
    }
    wint_t *dest=(wint_t *) malloc(sizeof(wint_t) * (w_len));
    w_len = 0;
    fseek(fpIn, 0, SEEK_SET);
    while((wc = fgetwc(fpIn))!=WEOF){
        dest[w_len++] = wc;
    }

    int dataIndex=0; //B
    char dataContainer[w_len][ARY_SIZE]; //q
    char finalContainer[w_len][ARY_SIZE];  //v

    char u;
    char s[ARY_SIZE];
    char z[ARY_SIZE];

    int t2 = 0;

    memset(dataContainer, 0, w_len * ARY_SIZE);
    memset(finalContainer, 0, w_len * ARY_SIZE);
    memset(z, 0, ARY_SIZE);
    memset(s, 0, ARY_SIZE);

    u = (char)dest[0];
    s[0] = u;
    finalContainer[0][0] = u;
    for(int i = 1; i < w_len; i++){
        int singleByteCheck = (int)dest[i];
        memset(z, 0, ARY_SIZE);
        if( singleByteCheck < 256 ){
            z[0] = (char)singleByteCheck;
        }else{
            if(dataContainer[singleByteCheck-256][0] !=0 ){
                for(t2=0; dataContainer[singleByteCheck-256][t2] != 0; t2++){
                    z[t2] = dataContainer[singleByteCheck-256][t2];
                }
            }else{
                for(t2=0; s[t2] != 0; t2++){
                    z[t2] = s[t2];
                }
                z[t2]=u;
            }
        }

        for(t2=0; z[t2] != 0; t2++){
            finalContainer[i][t2] = z[t2];
        }

        u = z[0];
        for(t2 = 0; s[t2] != 0; t2++){
            dataContainer[dataIndex][t2] = s[t2];
        }
        dataContainer[dataIndex][t2]=u;

        dataIndex++;
        memset(s, 0, ARY_SIZE);
        for(t2=0; z[t2] != 0; t2++){
            s[t2]=z[t2];
        }
    }

    for(int i = 0; i < w_len; i++){
        printf("%s", finalContainer[i]);
    }
    printf("\n");

    free(dest);
}

/*
    fseek(fpIn, 0, SEEK_END);
    int fileLen = ftell(fpIn);
    char *tmp = (char *) malloc(sizeof(char) * fileLen);
    fseek(fpIn, 0, SEEK_SET);
    fread(tmp, fileLen, sizeof(char), fpIn);
    fclose(fpIn);

    int w_len = mbstowcs(NULL, tmp, 0);
    //mbstowcs(dest, tmp, w_len + 1);
    //free(tmp);
    //printf("w_len=%d\n", w_len);
*/
