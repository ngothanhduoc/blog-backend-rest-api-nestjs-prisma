import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(@Req() request): string {
    console.log('params:', request.params);
    console.log('query::', request.query);
    console.log('body::', request.body);

    return this.appService.getHello();
  }

  @Post()
  postHello(@Req() request, @Body() body): string {
    console.log('params:', request);
    console.log('body::', body);
    const { headers } = request;

    if (headers['x-amz-sns-message-type'] === 'SubscriptionConfirmation') {
      console.log('arn' + headers['x-amz-sns-topic-arn']);
      const subscribeUrl = request.body.SubscribeURL;
      console.log('subscribeUrl ' + subscribeUrl);
    }

    return this.appService.getHello();
  }
}
