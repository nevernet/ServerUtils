import { Component, OnInit, AfterViewInit, } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Router, ActivatedRoute } from '@angular/router';
import { FileUploader, FileItem, ParsedResponseHeaders, FileUploaderOptions, FileLikeObject } from 'ng2-file-upload';


@Component({
    selector: 'app-fileu-pload',
    templateUrl: './fileu-pload.html',
    styleUrls: ['./file-upload.scss'],
    providers: [
    ]
})
export class FileUploadComponent implements OnInit, AfterViewInit {

    maxFileSize = 2 * 1024 * 1024; // 10 MB;
    allowedMimeType = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'];
    uploadOptions: FileUploaderOptions = {
        url: '', // 文件上传的路径
        autoUpload: true,
        allowedMimeType: this.allowedMimeType,
        maxFileSize: this.maxFileSize,
    };
    // 上传文件配置
    uploader_1: FileUploader = new FileUploader(this.uploadOptions);
    imageUrl1 = '';

    constructor(
        private router: Router,
        private route: ActivatedRoute,
    ) { }

    onFileUploadFinished = (item: FileItem, response: string, status: number, headers: ParsedResponseHeaders, isImageA = true) => {
        if (status !== 200) {
            console.log('上传失败，文件太大了');
            return;
        }
        // response: 将文件上传之后返回的文件服务器地址 response: {code：，msg: , data：{ 'url': '' }}
        // 解析 response
        try {
            const data = JSON.parse(response);
            if (data.code === 0) {
                console.log(data.data['url'])
                this.imageUrl1 = data.data['url'];
            } else {
                console.log(data.msg);
            }
        } catch (e) {

        }
    }

    onFileWhenAddingFileFailed = (item: FileLikeObject, filter: any, options: any) => {
        console.log('onFileWhenAddingFileFailed:', item);
        switch (filter.name) {
            case 'fileSize':
                console.log(`图片太大了，请上传2MB以内的图片`);
                break;
            case 'mimeType':
                const allowedTypes = this.allowedMimeType.join();
                console.log(`不支持的文件的格式，请选择图片上传`);
                break;
            default:
                console.log(`未知错误，请确认图片大小不超过2MB`);
        }
        this.uploader_1.clearQueue();
    }

    onFileBeforeUploadItem = (item: FileItem) => {
        console.log('onFileBeforeUploadItem:', item);
    }

    ngOnInit() {
    }

    ngAfterViewInit() {

        // 用户文件上传完成
        this.uploader_1.onCompleteItem = (item: FileItem, response: string, status: number, headers: ParsedResponseHeaders) => {
            console.log('onCompleteItem:', item);
            this.onFileUploadFinished(item, response, status, headers, true);
        };
        this.uploader_1.onAfterAddingFile = (item: FileItem) => {
            console.log('onAfterAddingFile:', item);
        };
        this.uploader_1.onErrorItem = (item: FileItem, response: string, status: number, headers: ParsedResponseHeaders) => {
            console.log('onErrorItem:', item);
        };
        this.uploader_1.onSuccessItem = (item: FileItem, response: string, status: number, headers: ParsedResponseHeaders) => {
            console.log('onSuccessItem:', item);
        };
        this.uploader_1.onCompleteAll = () => {
            console.log('onCompleteAll:', this.uploader_1.queue);
        };
        // 用户文件上传之前
        this.uploader_1.onBeforeUploadItem = this.onFileBeforeUploadItem;
        this.uploader_1.onWhenAddingFileFailed = this.onFileWhenAddingFileFailed;
    }
}
