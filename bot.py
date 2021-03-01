import os
import random
from re import UNICODE
import discord
from discord import FFmpegPCMAudio
from discord.ext.commands import Bot
import requests
from youtube_dl import YoutubeDL
from youtubesearchpython import SearchVideos
import json

with open('var.json') as var:
    token_raw = json.load(var)

TOKEN = token_raw["token"]
BOT_PREFIX = '?'

ydl_opts = {'format': 'bestaudio', 'noplaylist': 'True'}

client = discord.Client()
client = Bot(command_prefix=BOT_PREFIX)

radioDict = {
    'dave': [
        'http://onlineradiobox.com/uk/soulcentral/player/?cs=uk.soulcentral&played=1',
    ],
    'megaton': [
        'http://us2.internet-radio.com:8443/'
    ],
    'classical': [
        'http://uk2.internet-radio.com:31491/',
        'http://uk7.internet-radio.com:8000/',
        'http://uk3.internet-radio.com:8405/'
    ],
    'christmas': [
        'http://46.105.118.14:24000/',
        'http://uk1.internet-radio.com:8231/'
    ],
    'fusion': [
        'http://uk6.internet-radio.com:8346/'
    ],
    'funk': [
        'http://5.39.82.157:8054/'
    ],
    'lo-fi': [
        'http://82.14.214.56:8000/'
    ]
}

def botDestroyer(member):
    if member.bot is True:  
        return False
    else:
        return True

@client.event
async def on_voice_state_update(member, before, after):

    print(after.channel.members)
    filteredMemberList = list(filter(botDestroyer, after.channel.members))
    print(filteredMemberList)

    if before.channel is not None:
        if len(filteredMemberList) == 0:
            for voice in client.voice_clients:
                await voice.disconnect()

@client.command(name='DJ', aliases=['dj'])
async def dj(ctx):
    global botPlayer
    voiceChannel = ctx.author.voice.channel
    if voiceChannel:
        botPlayer = await voiceChannel.connect()


@client.command(name='dj_help', description='list commands')
async def help():
    return


@client.command(name='radio', aliases=['r', 'rad'], description='Play radio')
async def radio(ctx, arg):
    if arg in radioDict:
        stationType = radioDict[arg]
        radioStation = random.choice(stationType)
    else:
        await ctx.send(f'No radio with name {arg}')
        return

    botPlayer.stop()
    print(radioStation)
    await ctx.send(f'Playing {arg}')
    botPlayer.play(FFmpegPCMAudio(radioStation))


@client.command(name='stop', aliases=['s', 'st'], description='Stop radio')
async def stop(ctx):
    botPlayer.stop()


@client.command(name='youtube-search', aliases=['yt-search', 'tube-search'], description='search youtube')
async def yt_search(ctx, arg):

    print(arg)

    search = SearchVideos(arg ,offset=1, mode='json', max_results=20)
    results = json.loads(UNICODE(open(search.result())))['search_result']

    print(results[0])

    for result in results:
        title = result['title']
        thumb = requests.get(result['thumbnails'][0]).content
        await ctx.send(f'Result: ${title}')
        await ctx.send(discord.File(thumb))


@client.command(name='youtube-play', aliases=['yt-play', 'tube-play'], description='play youtube')
async def yt_play(ctx, arg):
    botPlayer.stop()

    yt_options = {
        'before_options': '-reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5', 'options': '-vn'}
    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(arg, download=False)

    url = info['formats'][0]['url']
    botPlayer.play(FFmpegPCMAudio(url, **yt_options))


@client.event
async def on_ready():
    print(f'{client.user} is online')

client.run(TOKEN)
