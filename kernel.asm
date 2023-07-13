
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 72 10 80       	push   $0x801072c0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 d1 44 00 00       	call   80104530 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 72 10 80       	push   $0x801072c7
80100097:	50                   	push   %eax
80100098:	e8 53 43 00 00       	call   801043f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 c3 45 00 00       	call   801046b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 42 00 00       	call   80104430 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 72 10 80       	push   $0x801072ce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 09 43 00 00       	call   801044d0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 72 10 80       	push   $0x801072df
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 c8 42 00 00       	call   801044d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 42 00 00       	call   80104490 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 8c 44 00 00       	call   801046b0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 44 00 00       	jmp    80104770 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 72 10 80       	push   $0x801072e6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 fa 43 00 00       	call   801046b0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 a6 3c 00 00       	call   80103f90 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 36 00 00       	call   80103980 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 5d 44 00 00       	call   80104770 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 06 44 00 00       	call   80104770 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 72 10 80       	push   $0x801072ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 1f 7c 10 80 	movl   $0x80107c1f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 41 00 00       	call   80104550 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 73 10 80       	push   $0x80107301
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 81 5a 00 00       	call   80105eb0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 96 59 00 00       	call   80105eb0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 8a 59 00 00       	call   80105eb0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 7e 59 00 00       	call   80105eb0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 fa 42 00 00       	call   80104860 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 42 00 00       	call   801047c0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 73 10 80       	push   $0x80107305
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 30 73 10 80 	movzbl -0x7fef8cd0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 4c 40 00 00       	call   801046b0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 d4 40 00 00       	call   80104770 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 18 73 10 80       	mov    $0x80107318,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 ee 3e 00 00       	call   801046b0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 43 3f 00 00       	call   80104770 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 73 10 80       	push   $0x8010731f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 34 3e 00 00       	call   801046b0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 9c 3d 00 00       	call   80104770 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 4c 38 00 00       	jmp    80104250 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 2b 37 00 00       	call   80104150 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 28 73 10 80       	push   $0x80107328
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 e7 3a 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 eb 2e 00 00       	call   80103980 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 0f 65 00 00       	call   80107020 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 c8 62 00 00       	call   80106e40 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 c2 61 00 00       	call   80106d70 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 b0 63 00 00       	call   80106fa0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 09 62 00 00       	call   80106e40 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 68 64 00 00       	call   801070c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 18 3d 00 00       	call   801049c0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 05 3d 00 00       	call   801049c0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 54 65 00 00       	call   80107220 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ba 62 00 00       	call   80106fa0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 e8 64 00 00       	call   80107220 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 0a 3c 00 00       	call   80104980 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 3e 5e 00 00       	call   80106be0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 f6 61 00 00       	call   80106fa0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 73 10 80       	push   $0x80107341
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 4d 73 10 80       	push   $0x8010734d
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 37 37 00 00       	call   80104530 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 96 38 00 00       	call   801046b0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 2a 39 00 00       	call   80104770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 11 39 00 00       	call   80104770 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 28 38 00 00       	call   801046b0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 cb 38 00 00       	call   80104770 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 54 73 10 80       	push   $0x80107354
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 d6 37 00 00       	call   801046b0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 5b 38 00 00       	call   80104770 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 2d 38 00 00       	jmp    80104770 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 5c 73 10 80       	push   $0x8010735c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 66 73 10 80       	push   $0x80107366
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 6f 73 10 80       	push   $0x8010736f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 75 73 10 80       	push   $0x80107375
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
80101202:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	89 fa                	mov    %edi,%edx
8010121b:	85 df                	test   %ebx,%edi
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 b4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 7f 73 10 80       	push   $0x8010737f
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 9e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101285:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101288:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010128a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 26 35 00 00       	call   801047c0 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 6e 1c 00 00       	call   80102f10 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 46 ef ff ff       	call   801001f0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
801012da:	e8 d1 33 00 00       	call   801046b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012e2:	83 c4 10             	add    $0x10,%esp
801012e5:	eb 1b                	jmp    80101302 <iget+0x42>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f0:	39 3b                	cmp    %edi,(%ebx)
801012f2:	74 6c                	je     80101360 <iget+0xa0>
801012f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101300:	73 26                	jae    80101328 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101302:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101305:	85 c9                	test   %ecx,%ecx
80101307:	7f e7                	jg     801012f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e7                	jne    801012f4 <iget+0x34>
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101315:	85 c9                	test   %ecx,%ecx
80101317:	75 6e                	jne    80101387 <iget+0xc7>
80101319:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101321:	72 df                	jb     80101302 <iget+0x42>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101328:	85 f6                	test   %esi,%esi
8010132a:	74 73                	je     8010139f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010132c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010132f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101331:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101334:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010133b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101342:	68 e0 09 11 80       	push   $0x801109e0
80101347:	e8 24 34 00 00       	call   80104770 <release>

  return ip;
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101352:	89 f0                	mov    %esi,%eax
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101360:	39 53 04             	cmp    %edx,0x4(%ebx)
80101363:	75 8f                	jne    801012f4 <iget+0x34>
      release(&icache.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101368:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010136b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010136d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 f6 33 00 00       	call   80104770 <release>
      return ip;
8010137a:	83 c4 10             	add    $0x10,%esp
}
8010137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101380:	89 f0                	mov    %esi,%eax
80101382:	5b                   	pop    %ebx
80101383:	5e                   	pop    %esi
80101384:	5f                   	pop    %edi
80101385:	5d                   	pop    %ebp
80101386:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101387:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 95 73 10 80       	push   $0x80107395
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	89 c6                	mov    %eax,%esi
801013b7:	53                   	push   %ebx
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	0f 86 84 00 00 00    	jbe    80101448 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013c7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ca:	0f 87 98 00 00 00    	ja     80101468 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013d6:	8b 16                	mov    (%esi),%edx
801013d8:	85 c0                	test   %eax,%eax
801013da:	74 54                	je     80101430 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013dc:	83 ec 08             	sub    $0x8,%esp
801013df:	50                   	push   %eax
801013e0:	52                   	push   %edx
801013e1:	e8 ea ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ed:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ef:	8b 1a                	mov    (%edx),%ebx
801013f1:	85 db                	test   %ebx,%ebx
801013f3:	74 1b                	je     80101410 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	57                   	push   %edi
801013f9:	e8 f2 ed ff ff       	call   801001f0 <brelse>
    return addr;
801013fe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 d8                	mov    %ebx,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010140f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101410:	8b 06                	mov    (%esi),%eax
80101412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101415:	e8 96 fd ff ff       	call   801011b0 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101420:	89 c3                	mov    %eax,%ebx
80101422:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 e6 1a 00 00       	call   80102f10 <log_write>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	eb c6                	jmp    801013f5 <bmap+0x45>
8010142f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	89 d0                	mov    %edx,%eax
80101432:	e8 79 fd ff ff       	call   801011b0 <balloc>
80101437:	8b 16                	mov    (%esi),%edx
80101439:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143f:	eb 9b                	jmp    801013dc <bmap+0x2c>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101448:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010144b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010144e:	85 db                	test   %ebx,%ebx
80101450:	75 af                	jne    80101401 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101452:	8b 00                	mov    (%eax),%eax
80101454:	e8 57 fd ff ff       	call   801011b0 <balloc>
80101459:	89 47 5c             	mov    %eax,0x5c(%edi)
8010145c:	89 c3                	mov    %eax,%ebx
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	89 d8                	mov    %ebx,%eax
80101463:	5b                   	pop    %ebx
80101464:	5e                   	pop    %esi
80101465:	5f                   	pop    %edi
80101466:	5d                   	pop    %ebp
80101467:	c3                   	ret    
  panic("bmap: out of range");
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	68 a5 73 10 80       	push   $0x801073a5
80101470:	e8 1b ef ff ff       	call   80100390 <panic>
80101475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	56                   	push   %esi
80101488:	53                   	push   %ebx
80101489:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010148c:	83 ec 08             	sub    $0x8,%esp
8010148f:	6a 01                	push   $0x1
80101491:	ff 75 08             	pushl  0x8(%ebp)
80101494:	e8 37 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101499:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010149c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010149e:	8d 40 5c             	lea    0x5c(%eax),%eax
801014a1:	6a 1c                	push   $0x1c
801014a3:	50                   	push   %eax
801014a4:	56                   	push   %esi
801014a5:	e8 b6 33 00 00       	call   80104860 <memmove>
  brelse(bp);
801014aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014ad:	83 c4 10             	add    $0x10,%esp
}
801014b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5d                   	pop    %ebp
  brelse(bp);
801014b6:	e9 35 ed ff ff       	jmp    801001f0 <brelse>
801014bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	89 c6                	mov    %eax,%esi
801014c6:	53                   	push   %ebx
801014c7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c0 09 11 80       	push   $0x801109c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801014e4:	50                   	push   %eax
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
  log_write(bp);
8010150e:	83 ec 0c             	sub    $0xc,%esp
80101511:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101519:	50                   	push   %eax
8010151a:	e8 f1 19 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 c9 ec ff ff       	call   801001f0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 b8 73 10 80       	push   $0x801073b8
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 cb 73 10 80       	push   $0x801073cb
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 d1 2f 00 00       	call   80104530 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 d2 73 10 80       	push   $0x801073d2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 74 2e 00 00       	call   801043f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010159d:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015af:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015b5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015bb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015c1:	68 38 74 10 80       	push   $0x80107438
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 5d 31 00 00       	call   801047c0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 30 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 d8 73 10 80       	push   $0x801073d8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 56 31 00 00       	call   80104860 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 09 11 80       	push   $0x801109e0
80101743:	e8 68 2f 00 00       	call   801046b0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101753:	e8 18 30 00 00       	call   80104770 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 a5 2c 00 00       	call   80104430 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 63 30 00 00       	call   80104860 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 f0 73 10 80       	push   $0x801073f0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ea 73 10 80       	push   $0x801073ea
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 74 2c 00 00       	call   801044d0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 18 2c 00 00       	jmp    80104490 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 ff 73 10 80       	push   $0x801073ff
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 87 2b 00 00       	call   80104430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 cd 2b 00 00       	call   80104490 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ca:	e8 e1 2d 00 00       	call   801046b0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 87 2e 00 00       	jmp    80104770 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 09 11 80       	push   $0x801109e0
801018f8:	e8 b3 2d 00 00       	call   801046b0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101907:	e8 64 2e 00 00       	call   80104770 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 84 fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 fc fa ff ff       	call   801014c0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 d5 fa ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 e1 f8 ff ff       	call   801013b0 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 54 2d 00 00       	call   80104860 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 e1 f7 ff ff       	call   801013b0 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 58 2c 00 00       	call   80104860 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 29 2c 00 00       	call   801048d0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 c6 2b 00 00       	call   801048d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 81 f5 ff ff       	call   801012c0 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 19 74 10 80       	push   $0x80107419
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 07 74 10 80       	push   $0x80107407
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 f1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 09 11 80       	push   $0x801109e0
80101d9c:	e8 0f 29 00 00       	call   801046b0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dac:	e8 bf 29 00 00       	call   80104770 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 44 2a 00 00       	call   80104860 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 b8 29 00 00       	call   80104860 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 9f f3 ff ff       	call   801012c0 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 46 29 00 00       	call   80104920 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 28 74 10 80       	push   $0x80107428
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 06 7a 10 80       	push   $0x80107a06
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 94 74 10 80       	push   $0x80107494
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 8b 74 10 80       	push   $0x8010748b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 a6 74 10 80       	push   $0x801074a6
8010215f:	68 80 a5 10 80       	push   $0x8010a580
80102164:	e8 c7 23 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 a5 10 80       	push   $0x8010a580
801021f2:	e8 b9 24 00 00       	call   801046b0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 fe 1e 00 00       	call   80104150 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 a5 10 80       	push   $0x8010a580
8010226b:	e8 00 25 00 00       	call   80104770 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 39 22 00 00       	call   801044d0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 a5 10 80       	push   $0x8010a580
801022cc:	e8 df 23 00 00       	call   801046b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 a5 10 80       	push   $0x8010a580
80102318:	53                   	push   %ebx
80102319:	e8 72 1c 00 00       	call   80103f90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 35 24 00 00       	jmp    80104770 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 d5 74 10 80       	push   $0x801074d5
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 c0 74 10 80       	push   $0x801074c0
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 aa 74 10 80       	push   $0x801074aa
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 f4 74 10 80       	push   $0x801074f4
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 56 12 80    	cmp    $0x801256a8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 15 23 00 00       	call   801047c0 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 26 11 80       	push   $0x80112640
801024e0:	e8 cb 21 00 00       	call   801046b0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 70 22 00 00       	jmp    80104770 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 26 75 10 80       	push   $0x80107526
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 2c 75 10 80       	push   $0x8010752c
80102574:	68 40 26 11 80       	push   $0x80112640
80102579:	e8 b2 1f 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 26 11 80       	mov    0x80112674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 26 11 80       	push   $0x80112640
80102663:	e8 48 20 00 00       	call   801046b0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010266d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 26 11 80       	push   $0x80112640
80102691:	e8 da 20 00 00       	call   80104770 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a 60 76 10 80 	movzbl -0x7fef89a0(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 40 75 10 80 	mov    -0x7fef8ac0(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a 60 76 10 80 	movzbl -0x7fef89a0(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 4c 1d 00 00       	call   80104810 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102bd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 67 1c 00 00       	call   80104860 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c3d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 60 77 10 80       	push   $0x80107760
80102ca3:	68 80 26 11 80       	push   $0x80112680
80102ca8:	e8 83 18 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 c7 e7 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 26 11 80       	push   $0x80112680
80102d3f:	e8 6c 19 00 00       	call   801046b0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 26 11 80       	push   $0x80112680
80102d58:	68 80 26 11 80       	push   $0x80112680
80102d5d:	e8 2e 12 00 00       	call   80103f90 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d73:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d8f:	68 80 26 11 80       	push   $0x80112680
80102d94:	e8 d7 19 00 00       	call   80104770 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 26 11 80       	push   $0x80112680
80102db2:	e8 f9 18 00 00       	call   801046b0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 26 11 80       	push   $0x80112680
80102df0:	e8 7b 19 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 26 11 80       	push   $0x80112680
80102e0a:	e8 a1 18 00 00       	call   801046b0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 2b 13 00 00       	call   80104150 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e2c:	e8 3f 19 00 00       	call   80104770 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e64:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 d7 19 00 00       	call   80104860 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 26 11 80       	push   $0x80112680
80102ed8:	e8 73 12 00 00       	call   80104150 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ee4:	e8 87 18 00 00       	call   80104770 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 64 77 10 80       	push   $0x80107764
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 26 11 80       	push   $0x80112680
80102f52:	e8 59 17 00 00       	call   801046b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 d6 17 00 00       	jmp    80104770 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 73 77 10 80       	push   $0x80107773
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 89 77 10 80       	push   $0x80107789
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 74 09 00 00       	call   80103960 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 6d 09 00 00       	call   80103960 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 a4 77 10 80       	push   $0x801077a4
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 e9 2a 00 00       	call   80105af0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 e4 08 00 00       	call   801038f0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 51 0c 00 00       	call   80103c70 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 91 3b 00 00       	call   80106bc0 <switchkvm>
  seginit();
8010302f:	e8 fc 3a 00 00       	call   80106b30 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 a8 56 12 80       	push   $0x801256a8
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 36 40 00 00       	call   801070a0 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 b7 3a 00 00       	call   80106b30 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 63 2d 00 00       	call   80105df0 <uartinit>
  pinit();         // process table
8010308d:	e8 3e 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
80103092:	e8 d9 29 00 00       	call   80105a70 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 8c a4 10 80       	push   $0x8010a48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 a3 17 00 00       	call   80104860 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030c7:	00 00 00 
801030ca:	05 80 27 11 80       	add    $0x80112780,%eax
801030cf:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 80 27 11 80       	add    $0x80112780,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 f2 07 00 00       	call   801038f0 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010311b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 49 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 b8 77 10 80       	push   $0x801077b8
801031a3:	56                   	push   %esi
801031a4:	e8 67 16 00 00       	call   80104810 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 bd 77 10 80       	push   $0x801077bd
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 a8 15 00 00       	call   80104810 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 c2 77 10 80       	push   $0x801077c2
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 dc 77 10 80       	push   $0x801077dc
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 fb 77 10 80       	push   $0x801077fb
8010346c:	50                   	push   %eax
8010346d:	e8 be 10 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 98 11 00 00       	call   801046b0 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 18 0c 00 00       	call   80104150 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 13 12 00 00       	jmp    80104770 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 d7 0b 00 00       	call   80104150 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 e7 11 00 00       	call   80104770 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 fa 10 00 00       	call   801046b0 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 83 03 00 00       	call   80103980 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 43 0b 00 00       	call   80104150 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 7a 09 00 00       	call   80103f90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 2f 11 00 00       	call   80104770 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 c1 0a 00 00       	call   80104150 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 d9 10 00 00       	call   80104770 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 f1 0f 00 00       	call   801046b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 a3 02 00 00       	call   80103980 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 9e 08 00 00       	call   80103f90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 f5 09 00 00       	call   80104150 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 0d 10 00 00       	call   80104770 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 f2 0f 00 00       	call   80104770 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 20 2d 11 80       	push   $0x80112d20
801037a1:	e8 0a 0f 00 00       	call   801046b0 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801037b6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801037bc:	0f 84 8e 00 00 00    	je     80103850 <allocproc+0xc0>
    if(p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
801037ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037d8:	89 43 10             	mov    %eax,0x10(%ebx)
801037db:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037de:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037e3:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
  release(&ptable.lock);
801037e9:	e8 82 0f 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037ee:	e8 3d ee ff ff       	call   80102630 <kalloc>
801037f3:	83 c4 10             	add    $0x10,%esp
801037f6:	89 43 08             	mov    %eax,0x8(%ebx)
801037f9:	85 c0                	test   %eax,%eax
801037fb:	74 6c                	je     80103869 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037fd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103803:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103806:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010380b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010380e:	c7 40 14 57 5a 10 80 	movl   $0x80105a57,0x14(%eax)
  p->context = (struct context*)sp;
80103815:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103818:	6a 14                	push   $0x14
8010381a:	6a 00                	push   $0x0
8010381c:	50                   	push   %eax
8010381d:	e8 9e 0f 00 00       	call   801047c0 <memset>
  p->context->eip = (uint)forkret;
80103822:	8b 43 1c             	mov    0x1c(%ebx),%eax

  //allocate a newly made proc to have 1 ticket by default and 0 ticks since it hasn't run yet
  p->num_tickets = 1;
  p->num_ticks = 0;

  return p;
80103825:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103828:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
8010382f:	89 d8                	mov    %ebx,%eax
  p->num_tickets = 1;
80103831:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->num_ticks = 0;
80103838:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010383f:	00 00 00 
}
80103842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103845:	c9                   	leave  
80103846:	c3                   	ret    
80103847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 2d 11 80       	push   $0x80112d20
8010385a:	e8 11 0f 00 00       	call   80104770 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 20 2d 11 80       	push   $0x80112d20
8010388f:	e8 dc 0e 00 00       	call   80104770 <release>

  if (first) {
80103894:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 84 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 c8 f3 ff ff       	call   80102c90 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038da:	68 00 78 10 80       	push   $0x80107800
801038df:	68 20 2d 11 80       	push   $0x80112d20
801038e4:	e8 47 0c 00 00       	call   80104530 <initlock>
}
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <mycpu>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	56                   	push   %esi
801038f8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f9:	9c                   	pushf  
801038fa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038fb:	f6 c4 02             	test   $0x2,%ah
801038fe:	75 4a                	jne    8010394a <mycpu+0x5a>
  apicid = lapicid();
80103900:	e8 9b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103905:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010390b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010390d:	85 f6                	test   %esi,%esi
8010390f:	7e 2c                	jle    8010393d <mycpu+0x4d>
80103911:	31 d2                	xor    %edx,%edx
80103913:	eb 0a                	jmp    8010391f <mycpu+0x2f>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
80103918:	83 c2 01             	add    $0x1,%edx
8010391b:	39 f2                	cmp    %esi,%edx
8010391d:	74 1e                	je     8010393d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010391f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103925:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010392c:	39 d8                	cmp    %ebx,%eax
8010392e:	75 e8                	jne    80103918 <mycpu+0x28>
}
80103930:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103933:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 07 78 10 80       	push   $0x80107807
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 e4 78 10 80       	push   $0x801078e4
80103952:	e8 39 ca ff ff       	call   80100390 <panic>
80103957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395e:	66 90                	xchg   %ax,%ax

80103960 <cpuid>:
cpuid() {
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010396a:	e8 81 ff ff ff       	call   801038f0 <mycpu>
}
8010396f:	c9                   	leave  
  return mycpu()-cpus;
80103970:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103975:	c1 f8 04             	sar    $0x4,%eax
80103978:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	53                   	push   %ebx
80103988:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010398b:	e8 20 0c 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103990:	e8 5b ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103995:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010399b:	e8 60 0c 00 00       	call   80104600 <popcli>
}
801039a0:	83 c4 04             	add    $0x4,%esp
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	5b                   	pop    %ebx
801039a6:	5d                   	pop    %ebp
801039a7:	c3                   	ret    
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039bb:	e8 d0 fd ff ff       	call   80103790 <allocproc>
801039c0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039c2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039c7:	e8 54 36 00 00       	call   80107020 <setupkvm>
801039cc:	89 43 04             	mov    %eax,0x4(%ebx)
801039cf:	85 c0                	test   %eax,%eax
801039d1:	0f 84 bd 00 00 00    	je     80103a94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d7:	83 ec 04             	sub    $0x4,%esp
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 a4 10 80       	push   $0x8010a460
801039e4:	50                   	push   %eax
801039e5:	e8 06 33 00 00       	call   80106cf0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 73 18             	pushl  0x18(%ebx)
801039fa:	e8 c1 0d 00 00       	call   801047c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 43 18             	mov    0x18(%ebx),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 43 18             	mov    0x18(%ebx),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 30 78 10 80       	push   $0x80107830
80103a58:	50                   	push   %eax
80103a59:	e8 22 0f 00 00       	call   80104980 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 39 78 10 80 	movl   $0x80107839,(%esp)
80103a65:	e8 c6 e5 ff ff       	call   80102030 <namei>
80103a6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a74:	e8 37 0c 00 00       	call   801046b0 <acquire>
  p->state = RUNNABLE;
80103a79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a87:	e8 e4 0c 00 00       	call   80104770 <release>
}
80103a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	c9                   	leave  
80103a93:	c3                   	ret    
    panic("userinit: out of memory?");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 17 78 10 80       	push   $0x80107817
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <growproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103abc:	e8 ef 0a 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103ac1:	e8 2a fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ac6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acc:	e8 2f 0b 00 00       	call   80104600 <popcli>
  sz = curproc->sz;
80103ad1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ad3:	85 f6                	test   %esi,%esi
80103ad5:	7f 19                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad7:	75 37                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103adc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ade:	53                   	push   %ebx
80103adf:	e8 fc 30 00 00       	call   80106be0 <switchuvm>
  return 0;
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	31 c0                	xor    %eax,%eax
}
80103ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aec:	5b                   	pop    %ebx
80103aed:	5e                   	pop    %esi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 41 33 00 00       	call   80106e40 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 d3                	jne    80103ad9 <growproc+0x29>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb dc                	jmp    80103ae9 <growproc+0x39>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 51 34 00 00       	call   80106f70 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 b3                	jne    80103ad9 <growproc+0x29>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b3d:	e8 6e 0a 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103b42:	e8 a9 fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4d:	e8 ae 0a 00 00       	call   80104600 <popcli>
  if((np = allocproc()) == 0){
80103b52:	e8 39 fc ff ff       	call   80103790 <allocproc>
80103b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	0f 84 c1 00 00 00    	je     80103c23 <fork+0xf3>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	ff 33                	pushl  (%ebx)
80103b67:	89 c7                	mov    %eax,%edi
80103b69:	ff 73 04             	pushl  0x4(%ebx)
80103b6c:	e8 7f 35 00 00       	call   801070f0 <copyuvm>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	89 47 04             	mov    %eax,0x4(%edi)
80103b77:	85 c0                	test   %eax,%eax
80103b79:	0f 84 ab 00 00 00    	je     80103c2a <fork+0xfa>
  np->sz = curproc->sz;
80103b7f:	8b 03                	mov    (%ebx),%eax
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b89:	89 c8                	mov    %ecx,%eax
80103b8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b93:	8b 73 18             	mov    0x18(%ebx),%esi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b9a:	8b 40 18             	mov    0x18(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 13                	je     80103bc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 b7 d2 ff ff       	call   80100e70 <filedup>
80103bb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bc3:	83 c6 01             	add    $0x1,%esi
80103bc6:	83 fe 10             	cmp    $0x10,%esi
80103bc9:	75 dd                	jne    80103ba8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 73 68             	pushl  0x68(%ebx)
80103bd1:	e8 5a db ff ff       	call   80101730 <idup>
80103bd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd9:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdc:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bdf:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103be2:	6a 10                	push   $0x10
80103be4:	50                   	push   %eax
80103be5:	8d 47 6c             	lea    0x6c(%edi),%eax
80103be8:	50                   	push   %eax
80103be9:	e8 92 0d 00 00       	call   80104980 <safestrcpy>
  pid = np->pid;
80103bee:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103bf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf8:	e8 b3 0a 00 00       	call   801046b0 <acquire>
  np->state = RUNNABLE;
80103bfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->num_tickets = curproc->num_tickets;
80103c04:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103c07:	89 47 7c             	mov    %eax,0x7c(%edi)
  release(&ptable.lock);
80103c0a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c11:	e8 5a 0b 00 00       	call   80104770 <release>
  return pid;
80103c16:	83 c4 10             	add    $0x10,%esp
}
80103c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c1c:	89 f0                	mov    %esi,%eax
80103c1e:	5b                   	pop    %ebx
80103c1f:	5e                   	pop    %esi
80103c20:	5f                   	pop    %edi
80103c21:	5d                   	pop    %ebp
80103c22:	c3                   	ret    
    return -1;
80103c23:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c28:	eb ef                	jmp    80103c19 <fork+0xe9>
    kfree(np->kstack);
80103c2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c2d:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c30:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c35:	ff 73 08             	pushl  0x8(%ebx)
80103c38:	e8 33 e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c3d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c44:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c47:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c4e:	eb c9                	jmp    80103c19 <fork+0xe9>

80103c50 <lcg_rand>:
unsigned int lcg_rand() {
80103c50:	f3 0f 1e fb          	endbr32 
  lcg_seed = 1664525 * lcg_seed + 1013904223;
80103c54:	69 05 04 a0 10 80 0d 	imul   $0x19660d,0x8010a004,%eax
80103c5b:	66 19 00 
80103c5e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
80103c63:	a3 04 a0 10 80       	mov    %eax,0x8010a004
}
80103c68:	c3                   	ret    
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <scheduler>:
{
80103c70:	f3 0f 1e fb          	endbr32 
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	57                   	push   %edi
80103c78:	56                   	push   %esi
80103c79:	53                   	push   %ebx
80103c7a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c7d:	e8 6e fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c82:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c89:	00 00 00 
  struct cpu *c = mycpu();
80103c8c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c8e:	8d 78 04             	lea    0x4(%eax),%edi
80103c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c98:	fb                   	sti    
    acquire(&ptable.lock);
80103c99:	83 ec 0c             	sub    $0xc,%esp
    acquire(&ptable.lock);
80103c9c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103ca1:	68 20 2d 11 80       	push   $0x80112d20
80103ca6:	e8 05 0a 00 00       	call   801046b0 <acquire>
    release(&ptable.lock);
80103cab:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cb2:	e8 b9 0a 00 00       	call   80104770 <release>
    acquire(&ptable.lock);
80103cb7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  lcg_seed = 1664525 * lcg_seed + 1013904223;
80103cbe:	69 05 04 a0 10 80 0d 	imul   $0x19660d,0x8010a004,%eax
80103cc5:	66 19 00 
80103cc8:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
80103ccd:	a3 04 a0 10 80       	mov    %eax,0x8010a004
    acquire(&ptable.lock);
80103cd2:	e8 d9 09 00 00       	call   801046b0 <acquire>
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ce0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ce4:	75 33                	jne    80103d19 <scheduler+0xa9>
      switchuvm(p);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ce9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cef:	53                   	push   %ebx
80103cf0:	e8 eb 2e 00 00       	call   80106be0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cf5:	58                   	pop    %eax
80103cf6:	5a                   	pop    %edx
80103cf7:	ff 73 1c             	pushl  0x1c(%ebx)
80103cfa:	57                   	push   %edi
      p->state = RUNNING;
80103cfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d02:	e8 dc 0c 00 00       	call   801049e3 <swtch>
      switchkvm();
80103d07:	e8 b4 2e 00 00       	call   80106bc0 <switchkvm>
      c->proc = 0;
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d16:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d19:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103d1f:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d25:	75 b9                	jne    80103ce0 <scheduler+0x70>
    release(&ptable.lock);
80103d27:	83 ec 0c             	sub    $0xc,%esp
80103d2a:	68 20 2d 11 80       	push   $0x80112d20
80103d2f:	e8 3c 0a 00 00       	call   80104770 <release>
  for(;;){
80103d34:	83 c4 10             	add    $0x10,%esp
80103d37:	e9 5c ff ff ff       	jmp    80103c98 <scheduler+0x28>
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d40 <sched>:
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	56                   	push   %esi
80103d48:	53                   	push   %ebx
  pushcli();
80103d49:	e8 62 08 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103d4e:	e8 9d fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103d53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d59:	e8 a2 08 00 00       	call   80104600 <popcli>
  if(!holding(&ptable.lock))
80103d5e:	83 ec 0c             	sub    $0xc,%esp
80103d61:	68 20 2d 11 80       	push   $0x80112d20
80103d66:	e8 f5 08 00 00       	call   80104660 <holding>
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	85 c0                	test   %eax,%eax
80103d70:	74 56                	je     80103dc8 <sched+0x88>
  if(mycpu()->ncli != 1)
80103d72:	e8 79 fb ff ff       	call   801038f0 <mycpu>
80103d77:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d7e:	75 6f                	jne    80103def <sched+0xaf>
  if(p->state == RUNNING)
80103d80:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d84:	74 5c                	je     80103de2 <sched+0xa2>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d86:	9c                   	pushf  
80103d87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d88:	f6 c4 02             	test   $0x2,%ah
80103d8b:	75 48                	jne    80103dd5 <sched+0x95>
  intena = mycpu()->intena;
80103d8d:	e8 5e fb ff ff       	call   801038f0 <mycpu>
80103d92:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  p->num_ticks += 1;
80103d98:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
  swtch(&p->context, mycpu()->scheduler);
80103d9f:	83 c3 1c             	add    $0x1c,%ebx
80103da2:	e8 49 fb ff ff       	call   801038f0 <mycpu>
80103da7:	83 ec 08             	sub    $0x8,%esp
80103daa:	ff 70 04             	pushl  0x4(%eax)
80103dad:	53                   	push   %ebx
80103dae:	e8 30 0c 00 00       	call   801049e3 <swtch>
  mycpu()->intena = intena;
80103db3:	e8 38 fb ff ff       	call   801038f0 <mycpu>
}
80103db8:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103dbb:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103dc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dc4:	5b                   	pop    %ebx
80103dc5:	5e                   	pop    %esi
80103dc6:	5d                   	pop    %ebp
80103dc7:	c3                   	ret    
    panic("sched ptable.lock");
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	68 3b 78 10 80       	push   $0x8010783b
80103dd0:	e8 bb c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dd5:	83 ec 0c             	sub    $0xc,%esp
80103dd8:	68 67 78 10 80       	push   $0x80107867
80103ddd:	e8 ae c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103de2:	83 ec 0c             	sub    $0xc,%esp
80103de5:	68 59 78 10 80       	push   $0x80107859
80103dea:	e8 a1 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	68 4d 78 10 80       	push   $0x8010784d
80103df7:	e8 94 c5 ff ff       	call   80100390 <panic>
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e00 <exit>:
{
80103e00:	f3 0f 1e fb          	endbr32 
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	57                   	push   %edi
80103e08:	56                   	push   %esi
80103e09:	53                   	push   %ebx
80103e0a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e0d:	e8 9e 07 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103e12:	e8 d9 fa ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103e17:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e1d:	e8 de 07 00 00       	call   80104600 <popcli>
  if(curproc == initproc)
80103e22:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e25:	8d 7e 68             	lea    0x68(%esi),%edi
80103e28:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e2e:	0f 84 fd 00 00 00    	je     80103f31 <exit+0x131>
80103e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e38:	8b 03                	mov    (%ebx),%eax
80103e3a:	85 c0                	test   %eax,%eax
80103e3c:	74 12                	je     80103e50 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e3e:	83 ec 0c             	sub    $0xc,%esp
80103e41:	50                   	push   %eax
80103e42:	e8 79 d0 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103e47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e4d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e50:	83 c3 04             	add    $0x4,%ebx
80103e53:	39 df                	cmp    %ebx,%edi
80103e55:	75 e1                	jne    80103e38 <exit+0x38>
  begin_op();
80103e57:	e8 d4 ee ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
80103e5c:	83 ec 0c             	sub    $0xc,%esp
80103e5f:	ff 76 68             	pushl  0x68(%esi)
80103e62:	e8 29 da ff ff       	call   80101890 <iput>
  end_op();
80103e67:	e8 34 ef ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80103e6c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e73:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e7a:	e8 31 08 00 00       	call   801046b0 <acquire>
  wakeup1(curproc->parent);
80103e7f:	8b 56 14             	mov    0x14(%esi),%edx
80103e82:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e85:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e8a:	eb 10                	jmp    80103e9c <exit+0x9c>
80103e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e90:	05 84 00 00 00       	add    $0x84,%eax
80103e95:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e9a:	74 1e                	je     80103eba <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103e9c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ea0:	75 ee                	jne    80103e90 <exit+0x90>
80103ea2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ea5:	75 e9                	jne    80103e90 <exit+0x90>
      p->state = RUNNABLE;
80103ea7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eae:	05 84 00 00 00       	add    $0x84,%eax
80103eb3:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103eb8:	75 e2                	jne    80103e9c <exit+0x9c>
      p->parent = initproc;
80103eba:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ec5:	eb 17                	jmp    80103ede <exit+0xde>
80103ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ece:	66 90                	xchg   %ax,%ax
80103ed0:	81 c2 84 00 00 00    	add    $0x84,%edx
80103ed6:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103edc:	74 3a                	je     80103f18 <exit+0x118>
    if(p->parent == curproc){
80103ede:	39 72 14             	cmp    %esi,0x14(%edx)
80103ee1:	75 ed                	jne    80103ed0 <exit+0xd0>
      if(p->state == ZOMBIE)
80103ee3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ee7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eea:	75 e4                	jne    80103ed0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ef1:	eb 11                	jmp    80103f04 <exit+0x104>
80103ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef7:	90                   	nop
80103ef8:	05 84 00 00 00       	add    $0x84,%eax
80103efd:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103f02:	74 cc                	je     80103ed0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103f04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f08:	75 ee                	jne    80103ef8 <exit+0xf8>
80103f0a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f0d:	75 e9                	jne    80103ef8 <exit+0xf8>
      p->state = RUNNABLE;
80103f0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f16:	eb e0                	jmp    80103ef8 <exit+0xf8>
  curproc->state = ZOMBIE;
80103f18:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f1f:	e8 1c fe ff ff       	call   80103d40 <sched>
  panic("zombie exit");
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	68 88 78 10 80       	push   $0x80107888
80103f2c:	e8 5f c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f31:	83 ec 0c             	sub    $0xc,%esp
80103f34:	68 7b 78 10 80       	push   $0x8010787b
80103f39:	e8 52 c4 ff ff       	call   80100390 <panic>
80103f3e:	66 90                	xchg   %ax,%ax

80103f40 <yield>:
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	53                   	push   %ebx
80103f48:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f4b:	68 20 2d 11 80       	push   $0x80112d20
80103f50:	e8 5b 07 00 00       	call   801046b0 <acquire>
  pushcli();
80103f55:	e8 56 06 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103f5a:	e8 91 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f65:	e8 96 06 00 00       	call   80104600 <popcli>
  myproc()->state = RUNNABLE;
80103f6a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f71:	e8 ca fd ff ff       	call   80103d40 <sched>
  release(&ptable.lock);
80103f76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7d:	e8 ee 07 00 00       	call   80104770 <release>
}
80103f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	c9                   	leave  
80103f89:	c3                   	ret    
80103f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f90 <sleep>:
{
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	57                   	push   %edi
80103f98:	56                   	push   %esi
80103f99:	53                   	push   %ebx
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fa3:	e8 08 06 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103fa8:	e8 43 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103fad:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb3:	e8 48 06 00 00       	call   80104600 <popcli>
  if(p == 0)
80103fb8:	85 db                	test   %ebx,%ebx
80103fba:	0f 84 83 00 00 00    	je     80104043 <sleep+0xb3>
  if(lk == 0)
80103fc0:	85 f6                	test   %esi,%esi
80103fc2:	74 72                	je     80104036 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fc4:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fca:	74 4c                	je     80104018 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	68 20 2d 11 80       	push   $0x80112d20
80103fd4:	e8 d7 06 00 00       	call   801046b0 <acquire>
    release(lk);
80103fd9:	89 34 24             	mov    %esi,(%esp)
80103fdc:	e8 8f 07 00 00       	call   80104770 <release>
  p->chan = chan;
80103fe1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fe4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103feb:	e8 50 fd ff ff       	call   80103d40 <sched>
  p->chan = 0;
80103ff0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ff7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ffe:	e8 6d 07 00 00       	call   80104770 <release>
    acquire(lk);
80104003:	89 75 08             	mov    %esi,0x8(%ebp)
80104006:	83 c4 10             	add    $0x10,%esp
}
80104009:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010400c:	5b                   	pop    %ebx
8010400d:	5e                   	pop    %esi
8010400e:	5f                   	pop    %edi
8010400f:	5d                   	pop    %ebp
    acquire(lk);
80104010:	e9 9b 06 00 00       	jmp    801046b0 <acquire>
80104015:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104018:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010401b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104022:	e8 19 fd ff ff       	call   80103d40 <sched>
  p->chan = 0;
80104027:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010402e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104031:	5b                   	pop    %ebx
80104032:	5e                   	pop    %esi
80104033:	5f                   	pop    %edi
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret    
    panic("sleep without lk");
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	68 9a 78 10 80       	push   $0x8010789a
8010403e:	e8 4d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	68 94 78 10 80       	push   $0x80107894
8010404b:	e8 40 c3 ff ff       	call   80100390 <panic>

80104050 <wait>:
{
80104050:	f3 0f 1e fb          	endbr32 
80104054:	55                   	push   %ebp
80104055:	89 e5                	mov    %esp,%ebp
80104057:	56                   	push   %esi
80104058:	53                   	push   %ebx
  pushcli();
80104059:	e8 52 05 00 00       	call   801045b0 <pushcli>
  c = mycpu();
8010405e:	e8 8d f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104063:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104069:	e8 92 05 00 00       	call   80104600 <popcli>
  acquire(&ptable.lock);
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	68 20 2d 11 80       	push   $0x80112d20
80104076:	e8 35 06 00 00       	call   801046b0 <acquire>
8010407b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010407e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104080:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104085:	eb 17                	jmp    8010409e <wait+0x4e>
80104087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408e:	66 90                	xchg   %ax,%ax
80104090:	81 c3 84 00 00 00    	add    $0x84,%ebx
80104096:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
8010409c:	74 1e                	je     801040bc <wait+0x6c>
      if(p->parent != curproc)
8010409e:	39 73 14             	cmp    %esi,0x14(%ebx)
801040a1:	75 ed                	jne    80104090 <wait+0x40>
      if(p->state == ZOMBIE){
801040a3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040a7:	74 37                	je     801040e0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a9:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
801040af:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b4:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801040ba:	75 e2                	jne    8010409e <wait+0x4e>
    if(!havekids || curproc->killed){
801040bc:	85 c0                	test   %eax,%eax
801040be:	74 76                	je     80104136 <wait+0xe6>
801040c0:	8b 46 24             	mov    0x24(%esi),%eax
801040c3:	85 c0                	test   %eax,%eax
801040c5:	75 6f                	jne    80104136 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040c7:	83 ec 08             	sub    $0x8,%esp
801040ca:	68 20 2d 11 80       	push   $0x80112d20
801040cf:	56                   	push   %esi
801040d0:	e8 bb fe ff ff       	call   80103f90 <sleep>
    havekids = 0;
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	eb a4                	jmp    8010407e <wait+0x2e>
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040e9:	e8 82 e3 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801040ee:	5a                   	pop    %edx
801040ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040f9:	e8 a2 2e 00 00       	call   80106fa0 <freevm>
        release(&ptable.lock);
801040fe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104105:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010410c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104113:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104117:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010411e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104125:	e8 46 06 00 00       	call   80104770 <release>
        return pid;
8010412a:	83 c4 10             	add    $0x10,%esp
}
8010412d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104130:	89 f0                	mov    %esi,%eax
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
      release(&ptable.lock);
80104136:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104139:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010413e:	68 20 2d 11 80       	push   $0x80112d20
80104143:	e8 28 06 00 00       	call   80104770 <release>
      return -1;
80104148:	83 c4 10             	add    $0x10,%esp
8010414b:	eb e0                	jmp    8010412d <wait+0xdd>
8010414d:	8d 76 00             	lea    0x0(%esi),%esi

80104150 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	53                   	push   %ebx
80104158:	83 ec 10             	sub    $0x10,%esp
8010415b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010415e:	68 20 2d 11 80       	push   $0x80112d20
80104163:	e8 48 05 00 00       	call   801046b0 <acquire>
80104168:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104170:	eb 12                	jmp    80104184 <wakeup+0x34>
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104178:	05 84 00 00 00       	add    $0x84,%eax
8010417d:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104182:	74 1e                	je     801041a2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104184:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104188:	75 ee                	jne    80104178 <wakeup+0x28>
8010418a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010418d:	75 e9                	jne    80104178 <wakeup+0x28>
      p->state = RUNNABLE;
8010418f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104196:	05 84 00 00 00       	add    $0x84,%eax
8010419b:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801041a0:	75 e2                	jne    80104184 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801041a2:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041ac:	c9                   	leave  
  release(&ptable.lock);
801041ad:	e9 be 05 00 00       	jmp    80104770 <release>
801041b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	53                   	push   %ebx
801041c8:	83 ec 10             	sub    $0x10,%esp
801041cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ce:	68 20 2d 11 80       	push   $0x80112d20
801041d3:	e8 d8 04 00 00       	call   801046b0 <acquire>
801041d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041db:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041e0:	eb 12                	jmp    801041f4 <kill+0x34>
801041e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041e8:	05 84 00 00 00       	add    $0x84,%eax
801041ed:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801041f2:	74 34                	je     80104228 <kill+0x68>
    if(p->pid == pid){
801041f4:	39 58 10             	cmp    %ebx,0x10(%eax)
801041f7:	75 ef                	jne    801041e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041f9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041fd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104204:	75 07                	jne    8010420d <kill+0x4d>
        p->state = RUNNABLE;
80104206:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 20 2d 11 80       	push   $0x80112d20
80104215:	e8 56 05 00 00       	call   80104770 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010421a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010421d:	83 c4 10             	add    $0x10,%esp
80104220:	31 c0                	xor    %eax,%eax
}
80104222:	c9                   	leave  
80104223:	c3                   	ret    
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 20 2d 11 80       	push   $0x80112d20
80104230:	e8 3b 05 00 00       	call   80104770 <release>
}
80104235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104240:	c9                   	leave  
80104241:	c3                   	ret    
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	57                   	push   %edi
80104258:	56                   	push   %esi
80104259:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010425c:	53                   	push   %ebx
8010425d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104262:	83 ec 3c             	sub    $0x3c,%esp
80104265:	eb 2b                	jmp    80104292 <procdump+0x42>
80104267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 1f 7c 10 80       	push   $0x80107c1f
80104278:	e8 33 c4 ff ff       	call   801006b0 <cprintf>
8010427d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104280:	81 c3 84 00 00 00    	add    $0x84,%ebx
80104286:	81 fb c0 4e 11 80    	cmp    $0x80114ec0,%ebx
8010428c:	0f 84 8e 00 00 00    	je     80104320 <procdump+0xd0>
    if(p->state == UNUSED)
80104292:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104295:	85 c0                	test   %eax,%eax
80104297:	74 e7                	je     80104280 <procdump+0x30>
      state = "???";
80104299:	ba ab 78 10 80       	mov    $0x801078ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010429e:	83 f8 05             	cmp    $0x5,%eax
801042a1:	77 11                	ja     801042b4 <procdump+0x64>
801042a3:	8b 14 85 0c 79 10 80 	mov    -0x7fef86f4(,%eax,4),%edx
      state = "???";
801042aa:	b8 ab 78 10 80       	mov    $0x801078ab,%eax
801042af:	85 d2                	test   %edx,%edx
801042b1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042b4:	53                   	push   %ebx
801042b5:	52                   	push   %edx
801042b6:	ff 73 a4             	pushl  -0x5c(%ebx)
801042b9:	68 af 78 10 80       	push   $0x801078af
801042be:	e8 ed c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042c3:	83 c4 10             	add    $0x10,%esp
801042c6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042ca:	75 a4                	jne    80104270 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042cc:	83 ec 08             	sub    $0x8,%esp
801042cf:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042d2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042d5:	50                   	push   %eax
801042d6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042d9:	8b 40 0c             	mov    0xc(%eax),%eax
801042dc:	83 c0 08             	add    $0x8,%eax
801042df:	50                   	push   %eax
801042e0:	e8 6b 02 00 00       	call   80104550 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop
801042f0:	8b 17                	mov    (%edi),%edx
801042f2:	85 d2                	test   %edx,%edx
801042f4:	0f 84 76 ff ff ff    	je     80104270 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042fa:	83 ec 08             	sub    $0x8,%esp
801042fd:	83 c7 04             	add    $0x4,%edi
80104300:	52                   	push   %edx
80104301:	68 01 73 10 80       	push   $0x80107301
80104306:	e8 a5 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	39 fe                	cmp    %edi,%esi
80104310:	75 de                	jne    801042f0 <procdump+0xa0>
80104312:	e9 59 ff ff ff       	jmp    80104270 <procdump+0x20>
80104317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431e:	66 90                	xchg   %ax,%ax
  }
}
80104320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104323:	5b                   	pop    %ebx
80104324:	5e                   	pop    %esi
80104325:	5f                   	pop    %edi
80104326:	5d                   	pop    %ebp
80104327:	c3                   	ret    
80104328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432f:	90                   	nop

80104330 <settickets>:

int settickets(int n){
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	53                   	push   %ebx
80104338:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010433b:	e8 70 02 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80104340:	e8 ab f5 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104345:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010434b:	e8 b0 02 00 00       	call   80104600 <popcli>
    struct proc *p = myproc();

    //Set tickets of the process to the number passed by the user
    p->num_tickets = n;
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	89 43 7c             	mov    %eax,0x7c(%ebx)

    return 0;
}
80104356:	83 c4 04             	add    $0x4,%esp
80104359:	31 c0                	xor    %eax,%eax
8010435b:	5b                   	pop    %ebx
8010435c:	5d                   	pop    %ebp
8010435d:	c3                   	ret    
8010435e:	66 90                	xchg   %ax,%ax

80104360 <getpinfo>:

int getpinfo(struct pstat *p){
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	53                   	push   %ebx
80104368:	83 ec 04             	sub    $0x4,%esp
8010436b:	8b 5d 08             	mov    0x8(%ebp),%ebx

  //check if NULL pointer
  if(p == 0){
8010436e:	85 db                	test   %ebx,%ebx
80104370:	74 6b                	je     801043dd <getpinfo+0x7d>
  }

  struct proc *pr;
  int i;

  acquire(&ptable.lock);
80104372:	83 ec 0c             	sub    $0xc,%esp
80104375:	68 20 2d 11 80       	push   $0x80112d20
8010437a:	e8 31 03 00 00       	call   801046b0 <acquire>

  //Set info about all running processes-like an update
  for (i = 0, pr = ptable.proc; i < NPROC && pr < &ptable.proc[NPROC]; i++, pr++) {
8010437f:	89 da                	mov    %ebx,%edx
80104381:	83 c4 10             	add    $0x10,%esp
80104384:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104389:	eb 08                	jmp    80104393 <getpinfo+0x33>
8010438b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010438f:	90                   	nop
80104390:	83 c2 04             	add    $0x4,%edx
    if (pr->state != UNUSED) {
80104393:	8b 58 0c             	mov    0xc(%eax),%ebx
80104396:	31 c9                	xor    %ecx,%ecx
80104398:	85 db                	test   %ebx,%ebx
8010439a:	0f 95 c1             	setne  %cl
  for (i = 0, pr = ptable.proc; i < NPROC && pr < &ptable.proc[NPROC]; i++, pr++) {
8010439d:	05 84 00 00 00       	add    $0x84,%eax
801043a2:	89 0a                	mov    %ecx,(%edx)
      p->inuse[i] = 1;
    } else {
      p->inuse[i] = 0;
    }

    p->tickets[i] = pr->num_tickets;
801043a4:	8b 48 f8             	mov    -0x8(%eax),%ecx
801043a7:	89 8a 00 01 00 00    	mov    %ecx,0x100(%edx)
    p->pid[i] = pr->pid;
801043ad:	8b 48 8c             	mov    -0x74(%eax),%ecx
801043b0:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
    p->ticks[i] = pr->num_ticks;
801043b6:	8b 48 fc             	mov    -0x4(%eax),%ecx
801043b9:	89 8a 00 03 00 00    	mov    %ecx,0x300(%edx)
  for (i = 0, pr = ptable.proc; i < NPROC && pr < &ptable.proc[NPROC]; i++, pr++) {
801043bf:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801043c4:	75 ca                	jne    80104390 <getpinfo+0x30>
  }

  release(&ptable.lock);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 20 2d 11 80       	push   $0x80112d20
801043ce:	e8 9d 03 00 00       	call   80104770 <release>

  //Success
  return 0;
801043d3:	83 c4 10             	add    $0x10,%esp
801043d6:	31 c0                	xor    %eax,%eax
}
801043d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043db:	c9                   	leave  
801043dc:	c3                   	ret    
    return -1;
801043dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e2:	eb f4                	jmp    801043d8 <getpinfo+0x78>
801043e4:	66 90                	xchg   %ax,%ax
801043e6:	66 90                	xchg   %ax,%ax
801043e8:	66 90                	xchg   %ax,%ax
801043ea:	66 90                	xchg   %ax,%ax
801043ec:	66 90                	xchg   %ax,%ax
801043ee:	66 90                	xchg   %ax,%ax

801043f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	53                   	push   %ebx
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043fe:	68 24 79 10 80       	push   $0x80107924
80104403:	8d 43 04             	lea    0x4(%ebx),%eax
80104406:	50                   	push   %eax
80104407:	e8 24 01 00 00       	call   80104530 <initlock>
  lk->name = name;
8010440c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010440f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104415:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104418:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010441f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104422:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104425:	c9                   	leave  
80104426:	c3                   	ret    
80104427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442e:	66 90                	xchg   %ax,%ax

80104430 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104430:	f3 0f 1e fb          	endbr32 
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	56                   	push   %esi
80104438:	53                   	push   %ebx
80104439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010443c:	8d 73 04             	lea    0x4(%ebx),%esi
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	56                   	push   %esi
80104443:	e8 68 02 00 00       	call   801046b0 <acquire>
  while (lk->locked) {
80104448:	8b 13                	mov    (%ebx),%edx
8010444a:	83 c4 10             	add    $0x10,%esp
8010444d:	85 d2                	test   %edx,%edx
8010444f:	74 1a                	je     8010446b <acquiresleep+0x3b>
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104458:	83 ec 08             	sub    $0x8,%esp
8010445b:	56                   	push   %esi
8010445c:	53                   	push   %ebx
8010445d:	e8 2e fb ff ff       	call   80103f90 <sleep>
  while (lk->locked) {
80104462:	8b 03                	mov    (%ebx),%eax
80104464:	83 c4 10             	add    $0x10,%esp
80104467:	85 c0                	test   %eax,%eax
80104469:	75 ed                	jne    80104458 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010446b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104471:	e8 0a f5 ff ff       	call   80103980 <myproc>
80104476:	8b 40 10             	mov    0x10(%eax),%eax
80104479:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010447c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010447f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
  release(&lk->lk);
80104485:	e9 e6 02 00 00       	jmp    80104770 <release>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	56                   	push   %esi
80104498:	53                   	push   %ebx
80104499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010449c:	8d 73 04             	lea    0x4(%ebx),%esi
8010449f:	83 ec 0c             	sub    $0xc,%esp
801044a2:	56                   	push   %esi
801044a3:	e8 08 02 00 00       	call   801046b0 <acquire>
  lk->locked = 0;
801044a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044b5:	89 1c 24             	mov    %ebx,(%esp)
801044b8:	e8 93 fc ff ff       	call   80104150 <wakeup>
  release(&lk->lk);
801044bd:	89 75 08             	mov    %esi,0x8(%ebp)
801044c0:	83 c4 10             	add    $0x10,%esp
}
801044c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c6:	5b                   	pop    %ebx
801044c7:	5e                   	pop    %esi
801044c8:	5d                   	pop    %ebp
  release(&lk->lk);
801044c9:	e9 a2 02 00 00       	jmp    80104770 <release>
801044ce:	66 90                	xchg   %ax,%ax

801044d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	31 ff                	xor    %edi,%edi
801044da:	56                   	push   %esi
801044db:	53                   	push   %ebx
801044dc:	83 ec 18             	sub    $0x18,%esp
801044df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044e2:	8d 73 04             	lea    0x4(%ebx),%esi
801044e5:	56                   	push   %esi
801044e6:	e8 c5 01 00 00       	call   801046b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044eb:	8b 03                	mov    (%ebx),%eax
801044ed:	83 c4 10             	add    $0x10,%esp
801044f0:	85 c0                	test   %eax,%eax
801044f2:	75 1c                	jne    80104510 <holdingsleep+0x40>
  release(&lk->lk);
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	56                   	push   %esi
801044f8:	e8 73 02 00 00       	call   80104770 <release>
  return r;
}
801044fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104500:	89 f8                	mov    %edi,%eax
80104502:	5b                   	pop    %ebx
80104503:	5e                   	pop    %esi
80104504:	5f                   	pop    %edi
80104505:	5d                   	pop    %ebp
80104506:	c3                   	ret    
80104507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104510:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104513:	e8 68 f4 ff ff       	call   80103980 <myproc>
80104518:	39 58 10             	cmp    %ebx,0x10(%eax)
8010451b:	0f 94 c0             	sete   %al
8010451e:	0f b6 c0             	movzbl %al,%eax
80104521:	89 c7                	mov    %eax,%edi
80104523:	eb cf                	jmp    801044f4 <holdingsleep+0x24>
80104525:	66 90                	xchg   %ax,%ax
80104527:	66 90                	xchg   %ax,%ax
80104529:	66 90                	xchg   %ax,%ax
8010452b:	66 90                	xchg   %ax,%ax
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010453a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010453d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104543:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104546:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010454d:	5d                   	pop    %ebp
8010454e:	c3                   	ret    
8010454f:	90                   	nop

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104555:	31 d2                	xor    %edx,%edx
{
80104557:	89 e5                	mov    %esp,%ebp
80104559:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010455a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010455d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104560:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104567:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104568:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010456e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104574:	77 1a                	ja     80104590 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104576:	8b 58 04             	mov    0x4(%eax),%ebx
80104579:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010457c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010457f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104581:	83 fa 0a             	cmp    $0xa,%edx
80104584:	75 e2                	jne    80104568 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104586:	5b                   	pop    %ebx
80104587:	5d                   	pop    %ebp
80104588:	c3                   	ret    
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104590:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104593:	8d 51 28             	lea    0x28(%ecx),%edx
80104596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045a6:	83 c0 04             	add    $0x4,%eax
801045a9:	39 d0                	cmp    %edx,%eax
801045ab:	75 f3                	jne    801045a0 <getcallerpcs+0x50>
}
801045ad:	5b                   	pop    %ebx
801045ae:	5d                   	pop    %ebp
801045af:	c3                   	ret    

801045b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	53                   	push   %ebx
801045b8:	83 ec 04             	sub    $0x4,%esp
801045bb:	9c                   	pushf  
801045bc:	5b                   	pop    %ebx
  asm volatile("cli");
801045bd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045be:	e8 2d f3 ff ff       	call   801038f0 <mycpu>
801045c3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045c9:	85 c0                	test   %eax,%eax
801045cb:	74 13                	je     801045e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045cd:	e8 1e f3 ff ff       	call   801038f0 <mycpu>
801045d2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045d9:	83 c4 04             	add    $0x4,%esp
801045dc:	5b                   	pop    %ebx
801045dd:	5d                   	pop    %ebp
801045de:	c3                   	ret    
801045df:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801045e0:	e8 0b f3 ff ff       	call   801038f0 <mycpu>
801045e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045f1:	eb da                	jmp    801045cd <pushcli+0x1d>
801045f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <popcli>:

void
popcli(void)
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010460a:	9c                   	pushf  
8010460b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010460c:	f6 c4 02             	test   $0x2,%ah
8010460f:	75 31                	jne    80104642 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104611:	e8 da f2 ff ff       	call   801038f0 <mycpu>
80104616:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010461d:	78 30                	js     8010464f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010461f:	e8 cc f2 ff ff       	call   801038f0 <mycpu>
80104624:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010462a:	85 d2                	test   %edx,%edx
8010462c:	74 02                	je     80104630 <popcli+0x30>
    sti();
}
8010462e:	c9                   	leave  
8010462f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104630:	e8 bb f2 ff ff       	call   801038f0 <mycpu>
80104635:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010463b:	85 c0                	test   %eax,%eax
8010463d:	74 ef                	je     8010462e <popcli+0x2e>
  asm volatile("sti");
8010463f:	fb                   	sti    
}
80104640:	c9                   	leave  
80104641:	c3                   	ret    
    panic("popcli - interruptible");
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	68 2f 79 10 80       	push   $0x8010792f
8010464a:	e8 41 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010464f:	83 ec 0c             	sub    $0xc,%esp
80104652:	68 46 79 10 80       	push   $0x80107946
80104657:	e8 34 bd ff ff       	call   80100390 <panic>
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <holding>:
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	56                   	push   %esi
80104668:	53                   	push   %ebx
80104669:	8b 75 08             	mov    0x8(%ebp),%esi
8010466c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010466e:	e8 3d ff ff ff       	call   801045b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104673:	8b 06                	mov    (%esi),%eax
80104675:	85 c0                	test   %eax,%eax
80104677:	75 0f                	jne    80104688 <holding+0x28>
  popcli();
80104679:	e8 82 ff ff ff       	call   80104600 <popcli>
}
8010467e:	89 d8                	mov    %ebx,%eax
80104680:	5b                   	pop    %ebx
80104681:	5e                   	pop    %esi
80104682:	5d                   	pop    %ebp
80104683:	c3                   	ret    
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104688:	8b 5e 08             	mov    0x8(%esi),%ebx
8010468b:	e8 60 f2 ff ff       	call   801038f0 <mycpu>
80104690:	39 c3                	cmp    %eax,%ebx
80104692:	0f 94 c3             	sete   %bl
  popcli();
80104695:	e8 66 ff ff ff       	call   80104600 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010469a:	0f b6 db             	movzbl %bl,%ebx
}
8010469d:	89 d8                	mov    %ebx,%eax
8010469f:	5b                   	pop    %ebx
801046a0:	5e                   	pop    %esi
801046a1:	5d                   	pop    %ebp
801046a2:	c3                   	ret    
801046a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <acquire>:
{
801046b0:	f3 0f 1e fb          	endbr32 
801046b4:	55                   	push   %ebp
801046b5:	89 e5                	mov    %esp,%ebp
801046b7:	56                   	push   %esi
801046b8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801046b9:	e8 f2 fe ff ff       	call   801045b0 <pushcli>
  if(holding(lk))
801046be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046c1:	83 ec 0c             	sub    $0xc,%esp
801046c4:	53                   	push   %ebx
801046c5:	e8 96 ff ff ff       	call   80104660 <holding>
801046ca:	83 c4 10             	add    $0x10,%esp
801046cd:	85 c0                	test   %eax,%eax
801046cf:	0f 85 7f 00 00 00    	jne    80104754 <acquire+0xa4>
801046d5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046d7:	ba 01 00 00 00       	mov    $0x1,%edx
801046dc:	eb 05                	jmp    801046e3 <acquire+0x33>
801046de:	66 90                	xchg   %ax,%ax
801046e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046e3:	89 d0                	mov    %edx,%eax
801046e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046e8:	85 c0                	test   %eax,%eax
801046ea:	75 f4                	jne    801046e0 <acquire+0x30>
  __sync_synchronize();
801046ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046f4:	e8 f7 f1 ff ff       	call   801038f0 <mycpu>
801046f9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046fc:	89 e8                	mov    %ebp,%eax
801046fe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104706:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010470c:	77 22                	ja     80104730 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 50 04             	mov    0x4(%eax),%edx
80104711:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104715:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104718:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010471a:	83 fe 0a             	cmp    $0xa,%esi
8010471d:	75 e1                	jne    80104700 <acquire+0x50>
}
8010471f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104722:	5b                   	pop    %ebx
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104730:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104734:	83 c3 34             	add    $0x34,%ebx
80104737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104746:	83 c0 04             	add    $0x4,%eax
80104749:	39 d8                	cmp    %ebx,%eax
8010474b:	75 f3                	jne    80104740 <acquire+0x90>
}
8010474d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104750:	5b                   	pop    %ebx
80104751:	5e                   	pop    %esi
80104752:	5d                   	pop    %ebp
80104753:	c3                   	ret    
    panic("acquire");
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	68 4d 79 10 80       	push   $0x8010794d
8010475c:	e8 2f bc ff ff       	call   80100390 <panic>
80104761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <release>:
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	53                   	push   %ebx
80104778:	83 ec 10             	sub    $0x10,%esp
8010477b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010477e:	53                   	push   %ebx
8010477f:	e8 dc fe ff ff       	call   80104660 <holding>
80104784:	83 c4 10             	add    $0x10,%esp
80104787:	85 c0                	test   %eax,%eax
80104789:	74 22                	je     801047ad <release+0x3d>
  lk->pcs[0] = 0;
8010478b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104792:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104799:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010479e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a7:	c9                   	leave  
  popcli();
801047a8:	e9 53 fe ff ff       	jmp    80104600 <popcli>
    panic("release");
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	68 55 79 10 80       	push   $0x80107955
801047b5:	e8 d6 bb ff ff       	call   80100390 <panic>
801047ba:	66 90                	xchg   %ax,%ax
801047bc:	66 90                	xchg   %ax,%ax
801047be:	66 90                	xchg   %ax,%ax

801047c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	57                   	push   %edi
801047c8:	8b 55 08             	mov    0x8(%ebp),%edx
801047cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ce:	53                   	push   %ebx
801047cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047d2:	89 d7                	mov    %edx,%edi
801047d4:	09 cf                	or     %ecx,%edi
801047d6:	83 e7 03             	and    $0x3,%edi
801047d9:	75 25                	jne    80104800 <memset+0x40>
    c &= 0xFF;
801047db:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047de:	c1 e0 18             	shl    $0x18,%eax
801047e1:	89 fb                	mov    %edi,%ebx
801047e3:	c1 e9 02             	shr    $0x2,%ecx
801047e6:	c1 e3 10             	shl    $0x10,%ebx
801047e9:	09 d8                	or     %ebx,%eax
801047eb:	09 f8                	or     %edi,%eax
801047ed:	c1 e7 08             	shl    $0x8,%edi
801047f0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047f2:	89 d7                	mov    %edx,%edi
801047f4:	fc                   	cld    
801047f5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047f7:	5b                   	pop    %ebx
801047f8:	89 d0                	mov    %edx,%eax
801047fa:	5f                   	pop    %edi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret    
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104800:	89 d7                	mov    %edx,%edi
80104802:	fc                   	cld    
80104803:	f3 aa                	rep stos %al,%es:(%edi)
80104805:	5b                   	pop    %ebx
80104806:	89 d0                	mov    %edx,%eax
80104808:	5f                   	pop    %edi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop

80104810 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104810:	f3 0f 1e fb          	endbr32 
80104814:	55                   	push   %ebp
80104815:	89 e5                	mov    %esp,%ebp
80104817:	56                   	push   %esi
80104818:	8b 75 10             	mov    0x10(%ebp),%esi
8010481b:	8b 55 08             	mov    0x8(%ebp),%edx
8010481e:	53                   	push   %ebx
8010481f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104822:	85 f6                	test   %esi,%esi
80104824:	74 2a                	je     80104850 <memcmp+0x40>
80104826:	01 c6                	add    %eax,%esi
80104828:	eb 10                	jmp    8010483a <memcmp+0x2a>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104830:	83 c0 01             	add    $0x1,%eax
80104833:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104836:	39 f0                	cmp    %esi,%eax
80104838:	74 16                	je     80104850 <memcmp+0x40>
    if(*s1 != *s2)
8010483a:	0f b6 0a             	movzbl (%edx),%ecx
8010483d:	0f b6 18             	movzbl (%eax),%ebx
80104840:	38 d9                	cmp    %bl,%cl
80104842:	74 ec                	je     80104830 <memcmp+0x20>
      return *s1 - *s2;
80104844:	0f b6 c1             	movzbl %cl,%eax
80104847:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104849:	5b                   	pop    %ebx
8010484a:	5e                   	pop    %esi
8010484b:	5d                   	pop    %ebp
8010484c:	c3                   	ret    
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
80104850:	5b                   	pop    %ebx
  return 0;
80104851:	31 c0                	xor    %eax,%eax
}
80104853:	5e                   	pop    %esi
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret    
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	8b 55 08             	mov    0x8(%ebp),%edx
8010486b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010486e:	56                   	push   %esi
8010486f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104872:	39 d6                	cmp    %edx,%esi
80104874:	73 2a                	jae    801048a0 <memmove+0x40>
80104876:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104879:	39 fa                	cmp    %edi,%edx
8010487b:	73 23                	jae    801048a0 <memmove+0x40>
8010487d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104880:	85 c9                	test   %ecx,%ecx
80104882:	74 13                	je     80104897 <memmove+0x37>
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104888:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010488c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010488f:	83 e8 01             	sub    $0x1,%eax
80104892:	83 f8 ff             	cmp    $0xffffffff,%eax
80104895:	75 f1                	jne    80104888 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104897:	5e                   	pop    %esi
80104898:	89 d0                	mov    %edx,%eax
8010489a:	5f                   	pop    %edi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret    
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801048a0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801048a3:	89 d7                	mov    %edx,%edi
801048a5:	85 c9                	test   %ecx,%ecx
801048a7:	74 ee                	je     80104897 <memmove+0x37>
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048b1:	39 f0                	cmp    %esi,%eax
801048b3:	75 fb                	jne    801048b0 <memmove+0x50>
}
801048b5:	5e                   	pop    %esi
801048b6:	89 d0                	mov    %edx,%eax
801048b8:	5f                   	pop    %edi
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801048c0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801048c4:	eb 9a                	jmp    80104860 <memmove>
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	56                   	push   %esi
801048d8:	8b 75 10             	mov    0x10(%ebp),%esi
801048db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048de:	53                   	push   %ebx
801048df:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801048e2:	85 f6                	test   %esi,%esi
801048e4:	74 32                	je     80104918 <strncmp+0x48>
801048e6:	01 c6                	add    %eax,%esi
801048e8:	eb 14                	jmp    801048fe <strncmp+0x2e>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f0:	38 da                	cmp    %bl,%dl
801048f2:	75 14                	jne    80104908 <strncmp+0x38>
    n--, p++, q++;
801048f4:	83 c0 01             	add    $0x1,%eax
801048f7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048fa:	39 f0                	cmp    %esi,%eax
801048fc:	74 1a                	je     80104918 <strncmp+0x48>
801048fe:	0f b6 11             	movzbl (%ecx),%edx
80104901:	0f b6 18             	movzbl (%eax),%ebx
80104904:	84 d2                	test   %dl,%dl
80104906:	75 e8                	jne    801048f0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104908:	0f b6 c2             	movzbl %dl,%eax
8010490b:	29 d8                	sub    %ebx,%eax
}
8010490d:	5b                   	pop    %ebx
8010490e:	5e                   	pop    %esi
8010490f:	5d                   	pop    %ebp
80104910:	c3                   	ret    
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104918:	5b                   	pop    %ebx
    return 0;
80104919:	31 c0                	xor    %eax,%eax
}
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    
8010491e:	66 90                	xchg   %ax,%ax

80104920 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	57                   	push   %edi
80104928:	56                   	push   %esi
80104929:	8b 75 08             	mov    0x8(%ebp),%esi
8010492c:	53                   	push   %ebx
8010492d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104930:	89 f2                	mov    %esi,%edx
80104932:	eb 1b                	jmp    8010494f <strncpy+0x2f>
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104938:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010493c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010493f:	83 c2 01             	add    $0x1,%edx
80104942:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104946:	89 f9                	mov    %edi,%ecx
80104948:	88 4a ff             	mov    %cl,-0x1(%edx)
8010494b:	84 c9                	test   %cl,%cl
8010494d:	74 09                	je     80104958 <strncpy+0x38>
8010494f:	89 c3                	mov    %eax,%ebx
80104951:	83 e8 01             	sub    $0x1,%eax
80104954:	85 db                	test   %ebx,%ebx
80104956:	7f e0                	jg     80104938 <strncpy+0x18>
    ;
  while(n-- > 0)
80104958:	89 d1                	mov    %edx,%ecx
8010495a:	85 c0                	test   %eax,%eax
8010495c:	7e 15                	jle    80104973 <strncpy+0x53>
8010495e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104960:	83 c1 01             	add    $0x1,%ecx
80104963:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104967:	89 c8                	mov    %ecx,%eax
80104969:	f7 d0                	not    %eax
8010496b:	01 d0                	add    %edx,%eax
8010496d:	01 d8                	add    %ebx,%eax
8010496f:	85 c0                	test   %eax,%eax
80104971:	7f ed                	jg     80104960 <strncpy+0x40>
  return os;
}
80104973:	5b                   	pop    %ebx
80104974:	89 f0                	mov    %esi,%eax
80104976:	5e                   	pop    %esi
80104977:	5f                   	pop    %edi
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	56                   	push   %esi
80104988:	8b 55 10             	mov    0x10(%ebp),%edx
8010498b:	8b 75 08             	mov    0x8(%ebp),%esi
8010498e:	53                   	push   %ebx
8010498f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104992:	85 d2                	test   %edx,%edx
80104994:	7e 21                	jle    801049b7 <safestrcpy+0x37>
80104996:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010499a:	89 f2                	mov    %esi,%edx
8010499c:	eb 12                	jmp    801049b0 <safestrcpy+0x30>
8010499e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049a0:	0f b6 08             	movzbl (%eax),%ecx
801049a3:	83 c0 01             	add    $0x1,%eax
801049a6:	83 c2 01             	add    $0x1,%edx
801049a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049ac:	84 c9                	test   %cl,%cl
801049ae:	74 04                	je     801049b4 <safestrcpy+0x34>
801049b0:	39 d8                	cmp    %ebx,%eax
801049b2:	75 ec                	jne    801049a0 <safestrcpy+0x20>
    ;
  *s = 0;
801049b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049b7:	89 f0                	mov    %esi,%eax
801049b9:	5b                   	pop    %ebx
801049ba:	5e                   	pop    %esi
801049bb:	5d                   	pop    %ebp
801049bc:	c3                   	ret    
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <strlen>:

int
strlen(const char *s)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049c5:	31 c0                	xor    %eax,%eax
{
801049c7:	89 e5                	mov    %esp,%ebp
801049c9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049cc:	80 3a 00             	cmpb   $0x0,(%edx)
801049cf:	74 10                	je     801049e1 <strlen+0x21>
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d8:	83 c0 01             	add    $0x1,%eax
801049db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049df:	75 f7                	jne    801049d8 <strlen+0x18>
    ;
  return n;
}
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret    

801049e3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049e7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049eb:	55                   	push   %ebp
  pushl %ebx
801049ec:	53                   	push   %ebx
  pushl %esi
801049ed:	56                   	push   %esi
  pushl %edi
801049ee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049ef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049f1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049f3:	5f                   	pop    %edi
  popl %esi
801049f4:	5e                   	pop    %esi
  popl %ebx
801049f5:	5b                   	pop    %ebx
  popl %ebp
801049f6:	5d                   	pop    %ebp
  ret
801049f7:	c3                   	ret    
801049f8:	66 90                	xchg   %ax,%ax
801049fa:	66 90                	xchg   %ax,%ax
801049fc:	66 90                	xchg   %ax,%ax
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	53                   	push   %ebx
80104a08:	83 ec 04             	sub    $0x4,%esp
80104a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a0e:	e8 6d ef ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a13:	8b 00                	mov    (%eax),%eax
80104a15:	39 d8                	cmp    %ebx,%eax
80104a17:	76 17                	jbe    80104a30 <fetchint+0x30>
80104a19:	8d 53 04             	lea    0x4(%ebx),%edx
80104a1c:	39 d0                	cmp    %edx,%eax
80104a1e:	72 10                	jb     80104a30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a20:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a23:	8b 13                	mov    (%ebx),%edx
80104a25:	89 10                	mov    %edx,(%eax)
  return 0;
80104a27:	31 c0                	xor    %eax,%eax
}
80104a29:	83 c4 04             	add    $0x4,%esp
80104a2c:	5b                   	pop    %ebx
80104a2d:	5d                   	pop    %ebp
80104a2e:	c3                   	ret    
80104a2f:	90                   	nop
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb f2                	jmp    80104a29 <fetchint+0x29>
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	53                   	push   %ebx
80104a48:	83 ec 04             	sub    $0x4,%esp
80104a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a4e:	e8 2d ef ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104a53:	39 18                	cmp    %ebx,(%eax)
80104a55:	76 31                	jbe    80104a88 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104a57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a5e:	39 d3                	cmp    %edx,%ebx
80104a60:	73 26                	jae    80104a88 <fetchstr+0x48>
80104a62:	89 d8                	mov    %ebx,%eax
80104a64:	eb 11                	jmp    80104a77 <fetchstr+0x37>
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	39 c2                	cmp    %eax,%edx
80104a75:	76 11                	jbe    80104a88 <fetchstr+0x48>
    if(*s == 0)
80104a77:	80 38 00             	cmpb   $0x0,(%eax)
80104a7a:	75 f4                	jne    80104a70 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a7c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104a7f:	29 d8                	sub    %ebx,%eax
}
80104a81:	5b                   	pop    %ebx
80104a82:	5d                   	pop    %ebp
80104a83:	c3                   	ret    
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a88:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a90:	5b                   	pop    %ebx
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	56                   	push   %esi
80104aa8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa9:	e8 d2 ee ff ff       	call   80103980 <myproc>
80104aae:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab1:	8b 40 18             	mov    0x18(%eax),%eax
80104ab4:	8b 40 44             	mov    0x44(%eax),%eax
80104ab7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104aba:	e8 c1 ee ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104abf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ac2:	8b 00                	mov    (%eax),%eax
80104ac4:	39 c6                	cmp    %eax,%esi
80104ac6:	73 18                	jae    80104ae0 <argint+0x40>
80104ac8:	8d 53 08             	lea    0x8(%ebx),%edx
80104acb:	39 d0                	cmp    %edx,%eax
80104acd:	72 11                	jb     80104ae0 <argint+0x40>
  *ip = *(int*)(addr);
80104acf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ad2:	8b 53 04             	mov    0x4(%ebx),%edx
80104ad5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ad7:	31 c0                	xor    %eax,%eax
}
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ae5:	eb f2                	jmp    80104ad9 <argint+0x39>
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	56                   	push   %esi
80104af8:	53                   	push   %ebx
80104af9:	83 ec 10             	sub    $0x10,%esp
80104afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104aff:	e8 7c ee ff ff       	call   80103980 <myproc>
 
  if(argint(n, &i) < 0)
80104b04:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104b07:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b0c:	50                   	push   %eax
80104b0d:	ff 75 08             	pushl  0x8(%ebp)
80104b10:	e8 8b ff ff ff       	call   80104aa0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b15:	83 c4 10             	add    $0x10,%esp
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	78 24                	js     80104b40 <argptr+0x50>
80104b1c:	85 db                	test   %ebx,%ebx
80104b1e:	78 20                	js     80104b40 <argptr+0x50>
80104b20:	8b 16                	mov    (%esi),%edx
80104b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b25:	39 c2                	cmp    %eax,%edx
80104b27:	76 17                	jbe    80104b40 <argptr+0x50>
80104b29:	01 c3                	add    %eax,%ebx
80104b2b:	39 da                	cmp    %ebx,%edx
80104b2d:	72 11                	jb     80104b40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b32:	89 02                	mov    %eax,(%edx)
  return 0;
80104b34:	31 c0                	xor    %eax,%eax
}
80104b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5d                   	pop    %ebp
80104b3c:	c3                   	ret    
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b45:	eb ef                	jmp    80104b36 <argptr+0x46>
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5d:	50                   	push   %eax
80104b5e:	ff 75 08             	pushl  0x8(%ebp)
80104b61:	e8 3a ff ff ff       	call   80104aa0 <argint>
80104b66:	83 c4 10             	add    $0x10,%esp
80104b69:	85 c0                	test   %eax,%eax
80104b6b:	78 13                	js     80104b80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b6d:	83 ec 08             	sub    $0x8,%esp
80104b70:	ff 75 0c             	pushl  0xc(%ebp)
80104b73:	ff 75 f4             	pushl  -0xc(%ebp)
80104b76:	e8 c5 fe ff ff       	call   80104a40 <fetchstr>
80104b7b:	83 c4 10             	add    $0x10,%esp
}
80104b7e:	c9                   	leave  
80104b7f:	c3                   	ret    
80104b80:	c9                   	leave  
    return -1;
80104b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b86:	c3                   	ret    
80104b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <syscall>:
[SYS_getpinfo] sys_getpinfo,
};

void
syscall(void)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	53                   	push   %ebx
80104b98:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b9b:	e8 e0 ed ff ff       	call   80103980 <myproc>
80104ba0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ba2:	8b 40 18             	mov    0x18(%eax),%eax
80104ba5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ba8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bab:	83 fa 16             	cmp    $0x16,%edx
80104bae:	77 20                	ja     80104bd0 <syscall+0x40>
80104bb0:	8b 14 85 80 79 10 80 	mov    -0x7fef8680(,%eax,4),%edx
80104bb7:	85 d2                	test   %edx,%edx
80104bb9:	74 15                	je     80104bd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bbb:	ff d2                	call   *%edx
80104bbd:	89 c2                	mov    %eax,%edx
80104bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80104bc2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104bd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bd4:	50                   	push   %eax
80104bd5:	ff 73 10             	pushl  0x10(%ebx)
80104bd8:	68 5d 79 10 80       	push   $0x8010795d
80104bdd:	e8 ce ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104be2:	8b 43 18             	mov    0x18(%ebx),%eax
80104be5:	83 c4 10             	add    $0x10,%esp
80104be8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf2:	c9                   	leave  
80104bf3:	c3                   	ret    
80104bf4:	66 90                	xchg   %ax,%ax
80104bf6:	66 90                	xchg   %ax,%ax
80104bf8:	66 90                	xchg   %ax,%ax
80104bfa:	66 90                	xchg   %ax,%ax
80104bfc:	66 90                	xchg   %ax,%ax
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c08:	53                   	push   %ebx
80104c09:	83 ec 44             	sub    $0x44,%esp
80104c0c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c12:	57                   	push   %edi
80104c13:	50                   	push   %eax
{
80104c14:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104c17:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c1a:	e8 31 d4 ff ff       	call   80102050 <nameiparent>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	0f 84 46 01 00 00    	je     80104d70 <create+0x170>
    return 0;
  ilock(dp);
80104c2a:	83 ec 0c             	sub    $0xc,%esp
80104c2d:	89 c3                	mov    %eax,%ebx
80104c2f:	50                   	push   %eax
80104c30:	e8 2b cb ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104c35:	83 c4 0c             	add    $0xc,%esp
80104c38:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c3b:	50                   	push   %eax
80104c3c:	57                   	push   %edi
80104c3d:	53                   	push   %ebx
80104c3e:	e8 6d d0 ff ff       	call   80101cb0 <dirlookup>
80104c43:	83 c4 10             	add    $0x10,%esp
80104c46:	89 c6                	mov    %eax,%esi
80104c48:	85 c0                	test   %eax,%eax
80104c4a:	74 54                	je     80104ca0 <create+0xa0>
    iunlockput(dp);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	53                   	push   %ebx
80104c50:	e8 ab cd ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104c55:	89 34 24             	mov    %esi,(%esp)
80104c58:	e8 03 cb ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c65:	75 19                	jne    80104c80 <create+0x80>
80104c67:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c6c:	75 12                	jne    80104c80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c71:	89 f0                	mov    %esi,%eax
80104c73:	5b                   	pop    %ebx
80104c74:	5e                   	pop    %esi
80104c75:	5f                   	pop    %edi
80104c76:	5d                   	pop    %ebp
80104c77:	c3                   	ret    
80104c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
    iunlockput(ip);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	56                   	push   %esi
    return 0;
80104c84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c86:	e8 75 cd ff ff       	call   80101a00 <iunlockput>
    return 0;
80104c8b:	83 c4 10             	add    $0x10,%esp
}
80104c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c91:	89 f0                	mov    %esi,%eax
80104c93:	5b                   	pop    %ebx
80104c94:	5e                   	pop    %esi
80104c95:	5f                   	pop    %edi
80104c96:	5d                   	pop    %ebp
80104c97:	c3                   	ret    
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ca0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ca4:	83 ec 08             	sub    $0x8,%esp
80104ca7:	50                   	push   %eax
80104ca8:	ff 33                	pushl  (%ebx)
80104caa:	e8 31 c9 ff ff       	call   801015e0 <ialloc>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	89 c6                	mov    %eax,%esi
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	0f 84 cd 00 00 00    	je     80104d89 <create+0x189>
  ilock(ip);
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 9b ca ff ff       	call   80101760 <ilock>
  ip->major = major;
80104cc5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104cc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ccd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104cd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cde:	89 34 24             	mov    %esi,(%esp)
80104ce1:	e8 ba c9 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104cee:	74 30                	je     80104d20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104cf0:	83 ec 04             	sub    $0x4,%esp
80104cf3:	ff 76 04             	pushl  0x4(%esi)
80104cf6:	57                   	push   %edi
80104cf7:	53                   	push   %ebx
80104cf8:	e8 73 d2 ff ff       	call   80101f70 <dirlink>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 78                	js     80104d7c <create+0x17c>
  iunlockput(dp);
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	53                   	push   %ebx
80104d08:	e8 f3 cc ff ff       	call   80101a00 <iunlockput>
  return ip;
80104d0d:	83 c4 10             	add    $0x10,%esp
}
80104d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d13:	89 f0                	mov    %esi,%eax
80104d15:	5b                   	pop    %ebx
80104d16:	5e                   	pop    %esi
80104d17:	5f                   	pop    %edi
80104d18:	5d                   	pop    %ebp
80104d19:	c3                   	ret    
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d28:	53                   	push   %ebx
80104d29:	e8 72 c9 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d2e:	83 c4 0c             	add    $0xc,%esp
80104d31:	ff 76 04             	pushl  0x4(%esi)
80104d34:	68 fc 79 10 80       	push   $0x801079fc
80104d39:	56                   	push   %esi
80104d3a:	e8 31 d2 ff ff       	call   80101f70 <dirlink>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	85 c0                	test   %eax,%eax
80104d44:	78 18                	js     80104d5e <create+0x15e>
80104d46:	83 ec 04             	sub    $0x4,%esp
80104d49:	ff 73 04             	pushl  0x4(%ebx)
80104d4c:	68 fb 79 10 80       	push   $0x801079fb
80104d51:	56                   	push   %esi
80104d52:	e8 19 d2 ff ff       	call   80101f70 <dirlink>
80104d57:	83 c4 10             	add    $0x10,%esp
80104d5a:	85 c0                	test   %eax,%eax
80104d5c:	79 92                	jns    80104cf0 <create+0xf0>
      panic("create dots");
80104d5e:	83 ec 0c             	sub    $0xc,%esp
80104d61:	68 ef 79 10 80       	push   $0x801079ef
80104d66:	e8 25 b6 ff ff       	call   80100390 <panic>
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop
}
80104d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d73:	31 f6                	xor    %esi,%esi
}
80104d75:	5b                   	pop    %ebx
80104d76:	89 f0                	mov    %esi,%eax
80104d78:	5e                   	pop    %esi
80104d79:	5f                   	pop    %edi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
    panic("create: dirlink");
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	68 fe 79 10 80       	push   $0x801079fe
80104d84:	e8 07 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 e0 79 10 80       	push   $0x801079e0
80104d91:	e8 fa b5 ff ff       	call   80100390 <panic>
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi

80104da0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	89 d6                	mov    %edx,%esi
80104da6:	53                   	push   %ebx
80104da7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104dac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104daf:	50                   	push   %eax
80104db0:	6a 00                	push   $0x0
80104db2:	e8 e9 fc ff ff       	call   80104aa0 <argint>
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	78 2a                	js     80104de8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dc2:	77 24                	ja     80104de8 <argfd.constprop.0+0x48>
80104dc4:	e8 b7 eb ff ff       	call   80103980 <myproc>
80104dc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dcc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	74 14                	je     80104de8 <argfd.constprop.0+0x48>
  if(pfd)
80104dd4:	85 db                	test   %ebx,%ebx
80104dd6:	74 02                	je     80104dda <argfd.constprop.0+0x3a>
    *pfd = fd;
80104dd8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104dda:	89 06                	mov    %eax,(%esi)
  return 0;
80104ddc:	31 c0                	xor    %eax,%eax
}
80104dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de1:	5b                   	pop    %ebx
80104de2:	5e                   	pop    %esi
80104de3:	5d                   	pop    %ebp
80104de4:	c3                   	ret    
80104de5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ded:	eb ef                	jmp    80104dde <argfd.constprop.0+0x3e>
80104def:	90                   	nop

80104df0 <sys_dup>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104df5:	31 c0                	xor    %eax,%eax
{
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	56                   	push   %esi
80104dfa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dfb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dfe:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e01:	e8 9a ff ff ff       	call   80104da0 <argfd.constprop.0>
80104e06:	85 c0                	test   %eax,%eax
80104e08:	78 1e                	js     80104e28 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104e0a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e0d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e0f:	e8 6c eb ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104e18:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e1c:	85 d2                	test   %edx,%edx
80104e1e:	74 20                	je     80104e40 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104e20:	83 c3 01             	add    $0x1,%ebx
80104e23:	83 fb 10             	cmp    $0x10,%ebx
80104e26:	75 f0                	jne    80104e18 <sys_dup+0x28>
}
80104e28:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e30:	89 d8                	mov    %ebx,%eax
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e40:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4a:	e8 21 c0 ff ff       	call   80100e70 <filedup>
  return fd;
80104e4f:	83 c4 10             	add    $0x10,%esp
}
80104e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e55:	89 d8                	mov    %ebx,%eax
80104e57:	5b                   	pop    %ebx
80104e58:	5e                   	pop    %esi
80104e59:	5d                   	pop    %ebp
80104e5a:	c3                   	ret    
80104e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop

80104e60 <sys_read>:
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e65:	31 c0                	xor    %eax,%eax
{
80104e67:	89 e5                	mov    %esp,%ebp
80104e69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e6c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e6f:	e8 2c ff ff ff       	call   80104da0 <argfd.constprop.0>
80104e74:	85 c0                	test   %eax,%eax
80104e76:	78 48                	js     80104ec0 <sys_read+0x60>
80104e78:	83 ec 08             	sub    $0x8,%esp
80104e7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e7e:	50                   	push   %eax
80104e7f:	6a 02                	push   $0x2
80104e81:	e8 1a fc ff ff       	call   80104aa0 <argint>
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	85 c0                	test   %eax,%eax
80104e8b:	78 33                	js     80104ec0 <sys_read+0x60>
80104e8d:	83 ec 04             	sub    $0x4,%esp
80104e90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e93:	ff 75 f0             	pushl  -0x10(%ebp)
80104e96:	50                   	push   %eax
80104e97:	6a 01                	push   $0x1
80104e99:	e8 52 fc ff ff       	call   80104af0 <argptr>
80104e9e:	83 c4 10             	add    $0x10,%esp
80104ea1:	85 c0                	test   %eax,%eax
80104ea3:	78 1b                	js     80104ec0 <sys_read+0x60>
  return fileread(f, p, n);
80104ea5:	83 ec 04             	sub    $0x4,%esp
80104ea8:	ff 75 f0             	pushl  -0x10(%ebp)
80104eab:	ff 75 f4             	pushl  -0xc(%ebp)
80104eae:	ff 75 ec             	pushl  -0x14(%ebp)
80104eb1:	e8 3a c1 ff ff       	call   80100ff0 <fileread>
80104eb6:	83 c4 10             	add    $0x10,%esp
}
80104eb9:	c9                   	leave  
80104eba:	c3                   	ret    
80104ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
80104ec0:	c9                   	leave  
    return -1;
80104ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec6:	c3                   	ret    
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <sys_write>:
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ed5:	31 c0                	xor    %eax,%eax
{
80104ed7:	89 e5                	mov    %esp,%ebp
80104ed9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104edc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104edf:	e8 bc fe ff ff       	call   80104da0 <argfd.constprop.0>
80104ee4:	85 c0                	test   %eax,%eax
80104ee6:	78 48                	js     80104f30 <sys_write+0x60>
80104ee8:	83 ec 08             	sub    $0x8,%esp
80104eeb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eee:	50                   	push   %eax
80104eef:	6a 02                	push   $0x2
80104ef1:	e8 aa fb ff ff       	call   80104aa0 <argint>
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	85 c0                	test   %eax,%eax
80104efb:	78 33                	js     80104f30 <sys_write+0x60>
80104efd:	83 ec 04             	sub    $0x4,%esp
80104f00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f03:	ff 75 f0             	pushl  -0x10(%ebp)
80104f06:	50                   	push   %eax
80104f07:	6a 01                	push   $0x1
80104f09:	e8 e2 fb ff ff       	call   80104af0 <argptr>
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	85 c0                	test   %eax,%eax
80104f13:	78 1b                	js     80104f30 <sys_write+0x60>
  return filewrite(f, p, n);
80104f15:	83 ec 04             	sub    $0x4,%esp
80104f18:	ff 75 f0             	pushl  -0x10(%ebp)
80104f1b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f1e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f21:	e8 6a c1 ff ff       	call   80101090 <filewrite>
80104f26:	83 c4 10             	add    $0x10,%esp
}
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    
80104f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop
80104f30:	c9                   	leave  
    return -1;
80104f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f36:	c3                   	ret    
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <sys_close>:
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f50:	e8 4b fe ff ff       	call   80104da0 <argfd.constprop.0>
80104f55:	85 c0                	test   %eax,%eax
80104f57:	78 27                	js     80104f80 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f59:	e8 22 ea ff ff       	call   80103980 <myproc>
80104f5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f61:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f64:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f6b:	00 
  fileclose(f);
80104f6c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6f:	e8 4c bf ff ff       	call   80100ec0 <fileclose>
  return 0;
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	31 c0                	xor    %eax,%eax
}
80104f79:	c9                   	leave  
80104f7a:	c3                   	ret    
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop
80104f80:	c9                   	leave  
    return -1;
80104f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f86:	c3                   	ret    
80104f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <sys_fstat>:
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f95:	31 c0                	xor    %eax,%eax
{
80104f97:	89 e5                	mov    %esp,%ebp
80104f99:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f9c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f9f:	e8 fc fd ff ff       	call   80104da0 <argfd.constprop.0>
80104fa4:	85 c0                	test   %eax,%eax
80104fa6:	78 30                	js     80104fd8 <sys_fstat+0x48>
80104fa8:	83 ec 04             	sub    $0x4,%esp
80104fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fae:	6a 14                	push   $0x14
80104fb0:	50                   	push   %eax
80104fb1:	6a 01                	push   $0x1
80104fb3:	e8 38 fb ff ff       	call   80104af0 <argptr>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	78 19                	js     80104fd8 <sys_fstat+0x48>
  return filestat(f, st);
80104fbf:	83 ec 08             	sub    $0x8,%esp
80104fc2:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc5:	ff 75 f0             	pushl  -0x10(%ebp)
80104fc8:	e8 d3 bf ff ff       	call   80100fa0 <filestat>
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	c9                   	leave  
80104fd1:	c3                   	ret    
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fd8:	c9                   	leave  
    return -1;
80104fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fde:	c3                   	ret    
80104fdf:	90                   	nop

80104fe0 <sys_link>:
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	57                   	push   %edi
80104fe8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fe9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fec:	53                   	push   %ebx
80104fed:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ff0:	50                   	push   %eax
80104ff1:	6a 00                	push   $0x0
80104ff3:	e8 58 fb ff ff       	call   80104b50 <argstr>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	0f 88 ff 00 00 00    	js     80105102 <sys_link+0x122>
80105003:	83 ec 08             	sub    $0x8,%esp
80105006:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105009:	50                   	push   %eax
8010500a:	6a 01                	push   $0x1
8010500c:	e8 3f fb ff ff       	call   80104b50 <argstr>
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	85 c0                	test   %eax,%eax
80105016:	0f 88 e6 00 00 00    	js     80105102 <sys_link+0x122>
  begin_op();
8010501c:	e8 0f dd ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	ff 75 d4             	pushl  -0x2c(%ebp)
80105027:	e8 04 d0 ff ff       	call   80102030 <namei>
8010502c:	83 c4 10             	add    $0x10,%esp
8010502f:	89 c3                	mov    %eax,%ebx
80105031:	85 c0                	test   %eax,%eax
80105033:	0f 84 e8 00 00 00    	je     80105121 <sys_link+0x141>
  ilock(ip);
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	50                   	push   %eax
8010503d:	e8 1e c7 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010504a:	0f 84 b9 00 00 00    	je     80105109 <sys_link+0x129>
  iupdate(ip);
80105050:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105053:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105058:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010505b:	53                   	push   %ebx
8010505c:	e8 3f c6 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105061:	89 1c 24             	mov    %ebx,(%esp)
80105064:	e8 d7 c7 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105069:	58                   	pop    %eax
8010506a:	5a                   	pop    %edx
8010506b:	57                   	push   %edi
8010506c:	ff 75 d0             	pushl  -0x30(%ebp)
8010506f:	e8 dc cf ff ff       	call   80102050 <nameiparent>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	89 c6                	mov    %eax,%esi
80105079:	85 c0                	test   %eax,%eax
8010507b:	74 5f                	je     801050dc <sys_link+0xfc>
  ilock(dp);
8010507d:	83 ec 0c             	sub    $0xc,%esp
80105080:	50                   	push   %eax
80105081:	e8 da c6 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105086:	8b 03                	mov    (%ebx),%eax
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	39 06                	cmp    %eax,(%esi)
8010508d:	75 41                	jne    801050d0 <sys_link+0xf0>
8010508f:	83 ec 04             	sub    $0x4,%esp
80105092:	ff 73 04             	pushl  0x4(%ebx)
80105095:	57                   	push   %edi
80105096:	56                   	push   %esi
80105097:	e8 d4 ce ff ff       	call   80101f70 <dirlink>
8010509c:	83 c4 10             	add    $0x10,%esp
8010509f:	85 c0                	test   %eax,%eax
801050a1:	78 2d                	js     801050d0 <sys_link+0xf0>
  iunlockput(dp);
801050a3:	83 ec 0c             	sub    $0xc,%esp
801050a6:	56                   	push   %esi
801050a7:	e8 54 c9 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801050ac:	89 1c 24             	mov    %ebx,(%esp)
801050af:	e8 dc c7 ff ff       	call   80101890 <iput>
  end_op();
801050b4:	e8 e7 dc ff ff       	call   80102da0 <end_op>
  return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5f                   	pop    %edi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	56                   	push   %esi
801050d4:	e8 27 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801050d9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050dc:	83 ec 0c             	sub    $0xc,%esp
801050df:	53                   	push   %ebx
801050e0:	e8 7b c6 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801050e5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050ea:	89 1c 24             	mov    %ebx,(%esp)
801050ed:	e8 ae c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801050f2:	89 1c 24             	mov    %ebx,(%esp)
801050f5:	e8 06 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050fa:	e8 a1 dc ff ff       	call   80102da0 <end_op>
  return -1;
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105107:	eb b5                	jmp    801050be <sys_link+0xde>
    iunlockput(ip);
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	53                   	push   %ebx
8010510d:	e8 ee c8 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105112:	e8 89 dc ff ff       	call   80102da0 <end_op>
    return -1;
80105117:	83 c4 10             	add    $0x10,%esp
8010511a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511f:	eb 9d                	jmp    801050be <sys_link+0xde>
    end_op();
80105121:	e8 7a dc ff ff       	call   80102da0 <end_op>
    return -1;
80105126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512b:	eb 91                	jmp    801050be <sys_link+0xde>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi

80105130 <sys_unlink>:
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	57                   	push   %edi
80105138:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105139:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010513c:	53                   	push   %ebx
8010513d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105140:	50                   	push   %eax
80105141:	6a 00                	push   $0x0
80105143:	e8 08 fa ff ff       	call   80104b50 <argstr>
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	85 c0                	test   %eax,%eax
8010514d:	0f 88 7d 01 00 00    	js     801052d0 <sys_unlink+0x1a0>
  begin_op();
80105153:	e8 d8 db ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105158:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010515b:	83 ec 08             	sub    $0x8,%esp
8010515e:	53                   	push   %ebx
8010515f:	ff 75 c0             	pushl  -0x40(%ebp)
80105162:	e8 e9 ce ff ff       	call   80102050 <nameiparent>
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	89 c6                	mov    %eax,%esi
8010516c:	85 c0                	test   %eax,%eax
8010516e:	0f 84 66 01 00 00    	je     801052da <sys_unlink+0x1aa>
  ilock(dp);
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	50                   	push   %eax
80105178:	e8 e3 c5 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010517d:	58                   	pop    %eax
8010517e:	5a                   	pop    %edx
8010517f:	68 fc 79 10 80       	push   $0x801079fc
80105184:	53                   	push   %ebx
80105185:	e8 06 cb ff ff       	call   80101c90 <namecmp>
8010518a:	83 c4 10             	add    $0x10,%esp
8010518d:	85 c0                	test   %eax,%eax
8010518f:	0f 84 03 01 00 00    	je     80105298 <sys_unlink+0x168>
80105195:	83 ec 08             	sub    $0x8,%esp
80105198:	68 fb 79 10 80       	push   $0x801079fb
8010519d:	53                   	push   %ebx
8010519e:	e8 ed ca ff ff       	call   80101c90 <namecmp>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	0f 84 ea 00 00 00    	je     80105298 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051ae:	83 ec 04             	sub    $0x4,%esp
801051b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051b4:	50                   	push   %eax
801051b5:	53                   	push   %ebx
801051b6:	56                   	push   %esi
801051b7:	e8 f4 ca ff ff       	call   80101cb0 <dirlookup>
801051bc:	83 c4 10             	add    $0x10,%esp
801051bf:	89 c3                	mov    %eax,%ebx
801051c1:	85 c0                	test   %eax,%eax
801051c3:	0f 84 cf 00 00 00    	je     80105298 <sys_unlink+0x168>
  ilock(ip);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	50                   	push   %eax
801051cd:	e8 8e c5 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051da:	0f 8e 23 01 00 00    	jle    80105303 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051e8:	74 66                	je     80105250 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051ea:	83 ec 04             	sub    $0x4,%esp
801051ed:	6a 10                	push   $0x10
801051ef:	6a 00                	push   $0x0
801051f1:	57                   	push   %edi
801051f2:	e8 c9 f5 ff ff       	call   801047c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051f7:	6a 10                	push   $0x10
801051f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801051fc:	57                   	push   %edi
801051fd:	56                   	push   %esi
801051fe:	e8 5d c9 ff ff       	call   80101b60 <writei>
80105203:	83 c4 20             	add    $0x20,%esp
80105206:	83 f8 10             	cmp    $0x10,%eax
80105209:	0f 85 e7 00 00 00    	jne    801052f6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010520f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105214:	0f 84 96 00 00 00    	je     801052b0 <sys_unlink+0x180>
  iunlockput(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	56                   	push   %esi
8010521e:	e8 dd c7 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105223:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105228:	89 1c 24             	mov    %ebx,(%esp)
8010522b:	e8 70 c4 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105230:	89 1c 24             	mov    %ebx,(%esp)
80105233:	e8 c8 c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105238:	e8 63 db ff ff       	call   80102da0 <end_op>
  return 0;
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	31 c0                	xor    %eax,%eax
}
80105242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105245:	5b                   	pop    %ebx
80105246:	5e                   	pop    %esi
80105247:	5f                   	pop    %edi
80105248:	5d                   	pop    %ebp
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105250:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105254:	76 94                	jbe    801051ea <sys_unlink+0xba>
80105256:	ba 20 00 00 00       	mov    $0x20,%edx
8010525b:	eb 0b                	jmp    80105268 <sys_unlink+0x138>
8010525d:	8d 76 00             	lea    0x0(%esi),%esi
80105260:	83 c2 10             	add    $0x10,%edx
80105263:	39 53 58             	cmp    %edx,0x58(%ebx)
80105266:	76 82                	jbe    801051ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105268:	6a 10                	push   $0x10
8010526a:	52                   	push   %edx
8010526b:	57                   	push   %edi
8010526c:	53                   	push   %ebx
8010526d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105270:	e8 eb c7 ff ff       	call   80101a60 <readi>
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010527b:	83 f8 10             	cmp    $0x10,%eax
8010527e:	75 69                	jne    801052e9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105280:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105285:	74 d9                	je     80105260 <sys_unlink+0x130>
    iunlockput(ip);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	53                   	push   %ebx
8010528b:	e8 70 c7 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105297:	90                   	nop
  iunlockput(dp);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	56                   	push   %esi
8010529c:	e8 5f c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
801052a1:	e8 fa da ff ff       	call   80102da0 <end_op>
  return -1;
801052a6:	83 c4 10             	add    $0x10,%esp
801052a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ae:	eb 92                	jmp    80105242 <sys_unlink+0x112>
    iupdate(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052b3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801052b8:	56                   	push   %esi
801052b9:	e8 e2 c3 ff ff       	call   801016a0 <iupdate>
801052be:	83 c4 10             	add    $0x10,%esp
801052c1:	e9 54 ff ff ff       	jmp    8010521a <sys_unlink+0xea>
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	e9 68 ff ff ff       	jmp    80105242 <sys_unlink+0x112>
    end_op();
801052da:	e8 c1 da ff ff       	call   80102da0 <end_op>
    return -1;
801052df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e4:	e9 59 ff ff ff       	jmp    80105242 <sys_unlink+0x112>
      panic("isdirempty: readi");
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	68 20 7a 10 80       	push   $0x80107a20
801052f1:	e8 9a b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052f6:	83 ec 0c             	sub    $0xc,%esp
801052f9:	68 32 7a 10 80       	push   $0x80107a32
801052fe:	e8 8d b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105303:	83 ec 0c             	sub    $0xc,%esp
80105306:	68 0e 7a 10 80       	push   $0x80107a0e
8010530b:	e8 80 b0 ff ff       	call   80100390 <panic>

80105310 <sys_open>:

int
sys_open(void)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	57                   	push   %edi
80105318:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105319:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010531c:	53                   	push   %ebx
8010531d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105320:	50                   	push   %eax
80105321:	6a 00                	push   $0x0
80105323:	e8 28 f8 ff ff       	call   80104b50 <argstr>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	0f 88 8a 00 00 00    	js     801053bd <sys_open+0xad>
80105333:	83 ec 08             	sub    $0x8,%esp
80105336:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105339:	50                   	push   %eax
8010533a:	6a 01                	push   $0x1
8010533c:	e8 5f f7 ff ff       	call   80104aa0 <argint>
80105341:	83 c4 10             	add    $0x10,%esp
80105344:	85 c0                	test   %eax,%eax
80105346:	78 75                	js     801053bd <sys_open+0xad>
    return -1;

  begin_op();
80105348:	e8 e3 d9 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
8010534d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105351:	75 75                	jne    801053c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105353:	83 ec 0c             	sub    $0xc,%esp
80105356:	ff 75 e0             	pushl  -0x20(%ebp)
80105359:	e8 d2 cc ff ff       	call   80102030 <namei>
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	89 c6                	mov    %eax,%esi
80105363:	85 c0                	test   %eax,%eax
80105365:	74 7e                	je     801053e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105367:	83 ec 0c             	sub    $0xc,%esp
8010536a:	50                   	push   %eax
8010536b:	e8 f0 c3 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105378:	0f 84 c2 00 00 00    	je     80105440 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010537e:	e8 7d ba ff ff       	call   80100e00 <filealloc>
80105383:	89 c7                	mov    %eax,%edi
80105385:	85 c0                	test   %eax,%eax
80105387:	74 23                	je     801053ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105389:	e8 f2 e5 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010538e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105390:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105394:	85 d2                	test   %edx,%edx
80105396:	74 60                	je     801053f8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105398:	83 c3 01             	add    $0x1,%ebx
8010539b:	83 fb 10             	cmp    $0x10,%ebx
8010539e:	75 f0                	jne    80105390 <sys_open+0x80>
    if(f)
      fileclose(f);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	57                   	push   %edi
801053a4:	e8 17 bb ff ff       	call   80100ec0 <fileclose>
801053a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	56                   	push   %esi
801053b0:	e8 4b c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
801053b5:	e8 e6 d9 ff ff       	call   80102da0 <end_op>
    return -1;
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053c2:	eb 6d                	jmp    80105431 <sys_open+0x121>
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053ce:	31 c9                	xor    %ecx,%ecx
801053d0:	ba 02 00 00 00       	mov    $0x2,%edx
801053d5:	6a 00                	push   $0x0
801053d7:	e8 24 f8 ff ff       	call   80104c00 <create>
    if(ip == 0){
801053dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053e1:	85 c0                	test   %eax,%eax
801053e3:	75 99                	jne    8010537e <sys_open+0x6e>
      end_op();
801053e5:	e8 b6 d9 ff ff       	call   80102da0 <end_op>
      return -1;
801053ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053ef:	eb 40                	jmp    80105431 <sys_open+0x121>
801053f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053ff:	56                   	push   %esi
80105400:	e8 3b c4 ff ff       	call   80101840 <iunlock>
  end_op();
80105405:	e8 96 d9 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010540a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105410:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105413:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105416:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105419:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010541b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105422:	f7 d0                	not    %eax
80105424:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105427:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010542a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010542d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105434:	89 d8                	mov    %ebx,%eax
80105436:	5b                   	pop    %ebx
80105437:	5e                   	pop    %esi
80105438:	5f                   	pop    %edi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105440:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105443:	85 c9                	test   %ecx,%ecx
80105445:	0f 84 33 ff ff ff    	je     8010537e <sys_open+0x6e>
8010544b:	e9 5c ff ff ff       	jmp    801053ac <sys_open+0x9c>

80105450 <sys_mkdir>:

int
sys_mkdir(void)
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010545a:	e8 d1 d8 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010545f:	83 ec 08             	sub    $0x8,%esp
80105462:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105465:	50                   	push   %eax
80105466:	6a 00                	push   $0x0
80105468:	e8 e3 f6 ff ff       	call   80104b50 <argstr>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 34                	js     801054a8 <sys_mkdir+0x58>
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547a:	31 c9                	xor    %ecx,%ecx
8010547c:	ba 01 00 00 00       	mov    $0x1,%edx
80105481:	6a 00                	push   $0x0
80105483:	e8 78 f7 ff ff       	call   80104c00 <create>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	85 c0                	test   %eax,%eax
8010548d:	74 19                	je     801054a8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	50                   	push   %eax
80105493:	e8 68 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105498:	e8 03 d9 ff ff       	call   80102da0 <end_op>
  return 0;
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	31 c0                	xor    %eax,%eax
}
801054a2:	c9                   	leave  
801054a3:	c3                   	ret    
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801054a8:	e8 f3 d8 ff ff       	call   80102da0 <end_op>
    return -1;
801054ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b2:	c9                   	leave  
801054b3:	c3                   	ret    
801054b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop

801054c0 <sys_mknod>:

int
sys_mknod(void)
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
801054c5:	89 e5                	mov    %esp,%ebp
801054c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054ca:	e8 61 d8 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054cf:	83 ec 08             	sub    $0x8,%esp
801054d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054d5:	50                   	push   %eax
801054d6:	6a 00                	push   $0x0
801054d8:	e8 73 f6 ff ff       	call   80104b50 <argstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 64                	js     80105548 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801054e4:	83 ec 08             	sub    $0x8,%esp
801054e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ea:	50                   	push   %eax
801054eb:	6a 01                	push   $0x1
801054ed:	e8 ae f5 ff ff       	call   80104aa0 <argint>
  if((argstr(0, &path)) < 0 ||
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 4f                	js     80105548 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801054f9:	83 ec 08             	sub    $0x8,%esp
801054fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ff:	50                   	push   %eax
80105500:	6a 02                	push   $0x2
80105502:	e8 99 f5 ff ff       	call   80104aa0 <argint>
     argint(1, &major) < 0 ||
80105507:	83 c4 10             	add    $0x10,%esp
8010550a:	85 c0                	test   %eax,%eax
8010550c:	78 3a                	js     80105548 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010550e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105512:	83 ec 0c             	sub    $0xc,%esp
80105515:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105519:	ba 03 00 00 00       	mov    $0x3,%edx
8010551e:	50                   	push   %eax
8010551f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105522:	e8 d9 f6 ff ff       	call   80104c00 <create>
     argint(2, &minor) < 0 ||
80105527:	83 c4 10             	add    $0x10,%esp
8010552a:	85 c0                	test   %eax,%eax
8010552c:	74 1a                	je     80105548 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010552e:	83 ec 0c             	sub    $0xc,%esp
80105531:	50                   	push   %eax
80105532:	e8 c9 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105537:	e8 64 d8 ff ff       	call   80102da0 <end_op>
  return 0;
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	31 c0                	xor    %eax,%eax
}
80105541:	c9                   	leave  
80105542:	c3                   	ret    
80105543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105547:	90                   	nop
    end_op();
80105548:	e8 53 d8 ff ff       	call   80102da0 <end_op>
    return -1;
8010554d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105552:	c9                   	leave  
80105553:	c3                   	ret    
80105554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010555f:	90                   	nop

80105560 <sys_chdir>:

int
sys_chdir(void)
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
80105565:	89 e5                	mov    %esp,%ebp
80105567:	56                   	push   %esi
80105568:	53                   	push   %ebx
80105569:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010556c:	e8 0f e4 ff ff       	call   80103980 <myproc>
80105571:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105573:	e8 b8 d7 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105578:	83 ec 08             	sub    $0x8,%esp
8010557b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557e:	50                   	push   %eax
8010557f:	6a 00                	push   $0x0
80105581:	e8 ca f5 ff ff       	call   80104b50 <argstr>
80105586:	83 c4 10             	add    $0x10,%esp
80105589:	85 c0                	test   %eax,%eax
8010558b:	78 73                	js     80105600 <sys_chdir+0xa0>
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	ff 75 f4             	pushl  -0xc(%ebp)
80105593:	e8 98 ca ff ff       	call   80102030 <namei>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	89 c3                	mov    %eax,%ebx
8010559d:	85 c0                	test   %eax,%eax
8010559f:	74 5f                	je     80105600 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055a1:	83 ec 0c             	sub    $0xc,%esp
801055a4:	50                   	push   %eax
801055a5:	e8 b6 c1 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
801055aa:	83 c4 10             	add    $0x10,%esp
801055ad:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b2:	75 2c                	jne    801055e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	53                   	push   %ebx
801055b8:	e8 83 c2 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801055bd:	58                   	pop    %eax
801055be:	ff 76 68             	pushl  0x68(%esi)
801055c1:	e8 ca c2 ff ff       	call   80101890 <iput>
  end_op();
801055c6:	e8 d5 d7 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
801055cb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	31 c0                	xor    %eax,%eax
}
801055d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d6:	5b                   	pop    %ebx
801055d7:	5e                   	pop    %esi
801055d8:	5d                   	pop    %ebp
801055d9:	c3                   	ret    
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 17 c4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801055e9:	e8 b2 d7 ff ff       	call   80102da0 <end_op>
    return -1;
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f6:	eb db                	jmp    801055d3 <sys_chdir+0x73>
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
    end_op();
80105600:	e8 9b d7 ff ff       	call   80102da0 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560a:	eb c7                	jmp    801055d3 <sys_chdir+0x73>
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_exec>:

int
sys_exec(void)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	57                   	push   %edi
80105618:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105619:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010561f:	53                   	push   %ebx
80105620:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105626:	50                   	push   %eax
80105627:	6a 00                	push   $0x0
80105629:	e8 22 f5 ff ff       	call   80104b50 <argstr>
8010562e:	83 c4 10             	add    $0x10,%esp
80105631:	85 c0                	test   %eax,%eax
80105633:	0f 88 8b 00 00 00    	js     801056c4 <sys_exec+0xb4>
80105639:	83 ec 08             	sub    $0x8,%esp
8010563c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105642:	50                   	push   %eax
80105643:	6a 01                	push   $0x1
80105645:	e8 56 f4 ff ff       	call   80104aa0 <argint>
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	85 c0                	test   %eax,%eax
8010564f:	78 73                	js     801056c4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105651:	83 ec 04             	sub    $0x4,%esp
80105654:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010565a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010565c:	68 80 00 00 00       	push   $0x80
80105661:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105667:	6a 00                	push   $0x0
80105669:	50                   	push   %eax
8010566a:	e8 51 f1 ff ff       	call   801047c0 <memset>
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105678:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010567e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105685:	83 ec 08             	sub    $0x8,%esp
80105688:	57                   	push   %edi
80105689:	01 f0                	add    %esi,%eax
8010568b:	50                   	push   %eax
8010568c:	e8 6f f3 ff ff       	call   80104a00 <fetchint>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	78 2c                	js     801056c4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105698:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010569e:	85 c0                	test   %eax,%eax
801056a0:	74 36                	je     801056d8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056a2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801056a8:	83 ec 08             	sub    $0x8,%esp
801056ab:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801056ae:	52                   	push   %edx
801056af:	50                   	push   %eax
801056b0:	e8 8b f3 ff ff       	call   80104a40 <fetchstr>
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	85 c0                	test   %eax,%eax
801056ba:	78 08                	js     801056c4 <sys_exec+0xb4>
  for(i=0;; i++){
801056bc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056bf:	83 fb 20             	cmp    $0x20,%ebx
801056c2:	75 b4                	jne    80105678 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801056c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056cc:	5b                   	pop    %ebx
801056cd:	5e                   	pop    %esi
801056ce:	5f                   	pop    %edi
801056cf:	5d                   	pop    %ebp
801056d0:	c3                   	ret    
801056d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801056d8:	83 ec 08             	sub    $0x8,%esp
801056db:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801056e1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056e8:	00 00 00 00 
  return exec(path, argv);
801056ec:	50                   	push   %eax
801056ed:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056f3:	e8 88 b3 ff ff       	call   80100a80 <exec>
801056f8:	83 c4 10             	add    $0x10,%esp
}
801056fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056fe:	5b                   	pop    %ebx
801056ff:	5e                   	pop    %esi
80105700:	5f                   	pop    %edi
80105701:	5d                   	pop    %ebp
80105702:	c3                   	ret    
80105703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <sys_pipe>:

int
sys_pipe(void)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	57                   	push   %edi
80105718:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105719:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010571c:	53                   	push   %ebx
8010571d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105720:	6a 08                	push   $0x8
80105722:	50                   	push   %eax
80105723:	6a 00                	push   $0x0
80105725:	e8 c6 f3 ff ff       	call   80104af0 <argptr>
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	85 c0                	test   %eax,%eax
8010572f:	78 4e                	js     8010577f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105731:	83 ec 08             	sub    $0x8,%esp
80105734:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105737:	50                   	push   %eax
80105738:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010573b:	50                   	push   %eax
8010573c:	e8 af dc ff ff       	call   801033f0 <pipealloc>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	78 37                	js     8010577f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105748:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010574b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010574d:	e8 2e e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105758:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010575c:	85 f6                	test   %esi,%esi
8010575e:	74 30                	je     80105790 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105760:	83 c3 01             	add    $0x1,%ebx
80105763:	83 fb 10             	cmp    $0x10,%ebx
80105766:	75 f0                	jne    80105758 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 e0             	pushl  -0x20(%ebp)
8010576e:	e8 4d b7 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105773:	58                   	pop    %eax
80105774:	ff 75 e4             	pushl  -0x1c(%ebp)
80105777:	e8 44 b7 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105784:	eb 5b                	jmp    801057e1 <sys_pipe+0xd1>
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105790:	8d 73 08             	lea    0x8(%ebx),%esi
80105793:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010579a:	e8 e1 e1 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579f:	31 d2                	xor    %edx,%edx
801057a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057ac:	85 c9                	test   %ecx,%ecx
801057ae:	74 20                	je     801057d0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801057b0:	83 c2 01             	add    $0x1,%edx
801057b3:	83 fa 10             	cmp    $0x10,%edx
801057b6:	75 f0                	jne    801057a8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801057b8:	e8 c3 e1 ff ff       	call   80103980 <myproc>
801057bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057c4:	00 
801057c5:	eb a1                	jmp    80105768 <sys_pipe+0x58>
801057c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057df:	31 c0                	xor    %eax,%eax
}
801057e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e4:	5b                   	pop    %ebx
801057e5:	5e                   	pop    %esi
801057e6:	5f                   	pop    %edi
801057e7:	5d                   	pop    %ebp
801057e8:	c3                   	ret    
801057e9:	66 90                	xchg   %ax,%ax
801057eb:	66 90                	xchg   %ax,%ax
801057ed:	66 90                	xchg   %ax,%ax
801057ef:	90                   	nop

801057f0 <sys_fork>:
int settickets(int);
int getpinfo(struct pstat *);

int
sys_fork(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
  return fork();
801057f4:	e9 37 e3 ff ff       	jmp    80103b30 <fork>
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_exit>:
}

int
sys_exit(void)
{
80105800:	f3 0f 1e fb          	endbr32 
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	83 ec 08             	sub    $0x8,%esp
  exit();
8010580a:	e8 f1 e5 ff ff       	call   80103e00 <exit>
  return 0;  // not reached
}
8010580f:	31 c0                	xor    %eax,%eax
80105811:	c9                   	leave  
80105812:	c3                   	ret    
80105813:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105820 <sys_wait>:

int
sys_wait(void)
{
80105820:	f3 0f 1e fb          	endbr32 
  return wait();
80105824:	e9 27 e8 ff ff       	jmp    80104050 <wait>
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_kill>:
}

int
sys_kill(void)
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010583a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583d:	50                   	push   %eax
8010583e:	6a 00                	push   $0x0
80105840:	e8 5b f2 ff ff       	call   80104aa0 <argint>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	85 c0                	test   %eax,%eax
8010584a:	78 14                	js     80105860 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010584c:	83 ec 0c             	sub    $0xc,%esp
8010584f:	ff 75 f4             	pushl  -0xc(%ebp)
80105852:	e8 69 e9 ff ff       	call   801041c0 <kill>
80105857:	83 c4 10             	add    $0x10,%esp
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105860:	c9                   	leave  
    return -1;
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax

80105870 <sys_getpid>:

int
sys_getpid(void)
{
80105870:	f3 0f 1e fb          	endbr32 
80105874:	55                   	push   %ebp
80105875:	89 e5                	mov    %esp,%ebp
80105877:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010587a:	e8 01 e1 ff ff       	call   80103980 <myproc>
8010587f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105882:	c9                   	leave  
80105883:	c3                   	ret    
80105884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop

80105890 <sys_sbrk>:

int
sys_sbrk(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105898:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010589b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010589e:	50                   	push   %eax
8010589f:	6a 00                	push   $0x0
801058a1:	e8 fa f1 ff ff       	call   80104aa0 <argint>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 23                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058ad:	e8 ce e0 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801058b2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058b5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058b7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ba:	e8 f1 e1 ff ff       	call   80103ab0 <growproc>
801058bf:	83 c4 10             	add    $0x10,%esp
801058c2:	85 c0                	test   %eax,%eax
801058c4:	78 0a                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058c6:	89 d8                	mov    %ebx,%eax
801058c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058cb:	c9                   	leave  
801058cc:	c3                   	ret    
801058cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058d5:	eb ef                	jmp    801058c6 <sys_sbrk+0x36>
801058d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058de:	66 90                	xchg   %ax,%ax

801058e0 <sys_sleep>:

int
sys_sleep(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ee:	50                   	push   %eax
801058ef:	6a 00                	push   $0x0
801058f1:	e8 aa f1 ff ff       	call   80104aa0 <argint>
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 c0                	test   %eax,%eax
801058fb:	0f 88 86 00 00 00    	js     80105987 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105901:	83 ec 0c             	sub    $0xc,%esp
80105904:	68 60 4e 12 80       	push   $0x80124e60
80105909:	e8 a2 ed ff ff       	call   801046b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010590e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105911:	8b 1d a0 56 12 80    	mov    0x801256a0,%ebx
  while(ticks - ticks0 < n){
80105917:	83 c4 10             	add    $0x10,%esp
8010591a:	85 d2                	test   %edx,%edx
8010591c:	75 23                	jne    80105941 <sys_sleep+0x61>
8010591e:	eb 50                	jmp    80105970 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	68 60 4e 12 80       	push   $0x80124e60
80105928:	68 a0 56 12 80       	push   $0x801256a0
8010592d:	e8 5e e6 ff ff       	call   80103f90 <sleep>
  while(ticks - ticks0 < n){
80105932:	a1 a0 56 12 80       	mov    0x801256a0,%eax
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	29 d8                	sub    %ebx,%eax
8010593c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010593f:	73 2f                	jae    80105970 <sys_sleep+0x90>
    if(myproc()->killed){
80105941:	e8 3a e0 ff ff       	call   80103980 <myproc>
80105946:	8b 40 24             	mov    0x24(%eax),%eax
80105949:	85 c0                	test   %eax,%eax
8010594b:	74 d3                	je     80105920 <sys_sleep+0x40>
      release(&tickslock);
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	68 60 4e 12 80       	push   $0x80124e60
80105955:	e8 16 ee ff ff       	call   80104770 <release>
  }
  release(&tickslock);
  return 0;
}
8010595a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	68 60 4e 12 80       	push   $0x80124e60
80105978:	e8 f3 ed ff ff       	call   80104770 <release>
  return 0;
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	31 c0                	xor    %eax,%eax
}
80105982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105985:	c9                   	leave  
80105986:	c3                   	ret    
    return -1;
80105987:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598c:	eb f4                	jmp    80105982 <sys_sleep+0xa2>
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	53                   	push   %ebx
80105998:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010599b:	68 60 4e 12 80       	push   $0x80124e60
801059a0:	e8 0b ed ff ff       	call   801046b0 <acquire>
  xticks = ticks;
801059a5:	8b 1d a0 56 12 80    	mov    0x801256a0,%ebx
  release(&tickslock);
801059ab:	c7 04 24 60 4e 12 80 	movl   $0x80124e60,(%esp)
801059b2:	e8 b9 ed ff ff       	call   80104770 <release>
  return xticks;
}
801059b7:	89 d8                	mov    %ebx,%eax
801059b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059bc:	c9                   	leave  
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_settickets>:

int
sys_settickets(void){
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	83 ec 20             	sub    $0x20,%esp
  int n;

  //check if the number passed in by the user is lesser than 0
  if(argint(0, &n) < 0)
801059ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059cd:	50                   	push   %eax
801059ce:	6a 00                	push   $0x0
801059d0:	e8 cb f0 ff ff       	call   80104aa0 <argint>
801059d5:	83 c4 10             	add    $0x10,%esp
801059d8:	85 c0                	test   %eax,%eax
801059da:	78 1c                	js     801059f8 <sys_settickets+0x38>
    return -1;
  
  //check if the number passed is lesser than 1, idk it worked this way
  if(n < 1)
801059dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059df:	85 c0                	test   %eax,%eax
801059e1:	7e 15                	jle    801059f8 <sys_settickets+0x38>
    return -1;
  
  return settickets(n);
801059e3:	83 ec 0c             	sub    $0xc,%esp
801059e6:	50                   	push   %eax
801059e7:	e8 44 e9 ff ff       	call   80104330 <settickets>
801059ec:	83 c4 10             	add    $0x10,%esp
}
801059ef:	c9                   	leave  
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f8:	c9                   	leave  
    return -1;
801059f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <sys_getpinfo>:

int
sys_getpinfo(void){
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  struct pstat *p;

  //Check if this was a bad pointer
  if (argptr(0, (void *)&p, sizeof(*p)) < 0) {
80105a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a0d:	68 00 04 00 00       	push   $0x400
80105a12:	50                   	push   %eax
80105a13:	6a 00                	push   $0x0
80105a15:	e8 d6 f0 ff ff       	call   80104af0 <argptr>
80105a1a:	83 c4 10             	add    $0x10,%esp
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	78 17                	js     80105a38 <sys_getpinfo+0x38>
    return -1;
  }

  return getpinfo(p);
80105a21:	83 ec 0c             	sub    $0xc,%esp
80105a24:	ff 75 f4             	pushl  -0xc(%ebp)
80105a27:	e8 34 e9 ff ff       	call   80104360 <getpinfo>
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	c9                   	leave  
80105a30:	c3                   	ret    
80105a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a38:	c9                   	leave  
    return -1;
80105a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3e:	c3                   	ret    

80105a3f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a3f:	1e                   	push   %ds
  pushl %es
80105a40:	06                   	push   %es
  pushl %fs
80105a41:	0f a0                	push   %fs
  pushl %gs
80105a43:	0f a8                	push   %gs
  pushal
80105a45:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a46:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a4a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a4c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a4e:	54                   	push   %esp
  call trap
80105a4f:	e8 cc 00 00 00       	call   80105b20 <trap>
  addl $4, %esp
80105a54:	83 c4 04             	add    $0x4,%esp

80105a57 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a57:	61                   	popa   
  popl %gs
80105a58:	0f a9                	pop    %gs
  popl %fs
80105a5a:	0f a1                	pop    %fs
  popl %es
80105a5c:	07                   	pop    %es
  popl %ds
80105a5d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a5e:	83 c4 08             	add    $0x8,%esp
  iret
80105a61:	cf                   	iret   
80105a62:	66 90                	xchg   %ax,%ax
80105a64:	66 90                	xchg   %ax,%ax
80105a66:	66 90                	xchg   %ax,%ax
80105a68:	66 90                	xchg   %ax,%ax
80105a6a:	66 90                	xchg   %ax,%ax
80105a6c:	66 90                	xchg   %ax,%ax
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a75:	31 c0                	xor    %eax,%eax
{
80105a77:	89 e5                	mov    %esp,%ebp
80105a79:	83 ec 08             	sub    $0x8,%esp
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a80:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105a87:	c7 04 c5 a2 4e 12 80 	movl   $0x8e000008,-0x7fedb15e(,%eax,8)
80105a8e:	08 00 00 8e 
80105a92:	66 89 14 c5 a0 4e 12 	mov    %dx,-0x7fedb160(,%eax,8)
80105a99:	80 
80105a9a:	c1 ea 10             	shr    $0x10,%edx
80105a9d:	66 89 14 c5 a6 4e 12 	mov    %dx,-0x7fedb15a(,%eax,8)
80105aa4:	80 
  for(i = 0; i < 256; i++)
80105aa5:	83 c0 01             	add    $0x1,%eax
80105aa8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105aad:	75 d1                	jne    80105a80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105aaf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ab2:	a1 0c a1 10 80       	mov    0x8010a10c,%eax
80105ab7:	c7 05 a2 50 12 80 08 	movl   $0xef000008,0x801250a2
80105abe:	00 00 ef 
  initlock(&tickslock, "time");
80105ac1:	68 41 7a 10 80       	push   $0x80107a41
80105ac6:	68 60 4e 12 80       	push   $0x80124e60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105acb:	66 a3 a0 50 12 80    	mov    %ax,0x801250a0
80105ad1:	c1 e8 10             	shr    $0x10,%eax
80105ad4:	66 a3 a6 50 12 80    	mov    %ax,0x801250a6
  initlock(&tickslock, "time");
80105ada:	e8 51 ea ff ff       	call   80104530 <initlock>
}
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	c9                   	leave  
80105ae3:	c3                   	ret    
80105ae4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop

80105af0 <idtinit>:

void
idtinit(void)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
  pd[0] = size-1;
80105af5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105afa:	89 e5                	mov    %esp,%ebp
80105afc:	83 ec 10             	sub    $0x10,%esp
80105aff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b03:	b8 a0 4e 12 80       	mov    $0x80124ea0,%eax
80105b08:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b0c:	c1 e8 10             	shr    $0x10,%eax
80105b0f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b13:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b16:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b19:	c9                   	leave  
80105b1a:	c3                   	ret    
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop

80105b20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
80105b29:	53                   	push   %ebx
80105b2a:	83 ec 1c             	sub    $0x1c,%esp
80105b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b30:	8b 43 30             	mov    0x30(%ebx),%eax
80105b33:	83 f8 40             	cmp    $0x40,%eax
80105b36:	0f 84 bc 01 00 00    	je     80105cf8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b3c:	83 e8 20             	sub    $0x20,%eax
80105b3f:	83 f8 1f             	cmp    $0x1f,%eax
80105b42:	77 08                	ja     80105b4c <trap+0x2c>
80105b44:	3e ff 24 85 e8 7a 10 	notrack jmp *-0x7fef8518(,%eax,4)
80105b4b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b4c:	e8 2f de ff ff       	call   80103980 <myproc>
80105b51:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b54:	85 c0                	test   %eax,%eax
80105b56:	0f 84 eb 01 00 00    	je     80105d47 <trap+0x227>
80105b5c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b60:	0f 84 e1 01 00 00    	je     80105d47 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b66:	0f 20 d1             	mov    %cr2,%ecx
80105b69:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b6c:	e8 ef dd ff ff       	call   80103960 <cpuid>
80105b71:	8b 73 30             	mov    0x30(%ebx),%esi
80105b74:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b77:	8b 43 34             	mov    0x34(%ebx),%eax
80105b7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b7d:	e8 fe dd ff ff       	call   80103980 <myproc>
80105b82:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b85:	e8 f6 dd ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b8a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b90:	51                   	push   %ecx
80105b91:	57                   	push   %edi
80105b92:	52                   	push   %edx
80105b93:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b96:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b97:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105b9a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b9d:	56                   	push   %esi
80105b9e:	ff 70 10             	pushl  0x10(%eax)
80105ba1:	68 a4 7a 10 80       	push   $0x80107aa4
80105ba6:	e8 05 ab ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105bab:	83 c4 20             	add    $0x20,%esp
80105bae:	e8 cd dd ff ff       	call   80103980 <myproc>
80105bb3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bba:	e8 c1 dd ff ff       	call   80103980 <myproc>
80105bbf:	85 c0                	test   %eax,%eax
80105bc1:	74 1d                	je     80105be0 <trap+0xc0>
80105bc3:	e8 b8 dd ff ff       	call   80103980 <myproc>
80105bc8:	8b 50 24             	mov    0x24(%eax),%edx
80105bcb:	85 d2                	test   %edx,%edx
80105bcd:	74 11                	je     80105be0 <trap+0xc0>
80105bcf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bd3:	83 e0 03             	and    $0x3,%eax
80105bd6:	66 83 f8 03          	cmp    $0x3,%ax
80105bda:	0f 84 50 01 00 00    	je     80105d30 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	e8 9b dd ff ff       	call   80103980 <myproc>
80105be5:	85 c0                	test   %eax,%eax
80105be7:	74 0f                	je     80105bf8 <trap+0xd8>
80105be9:	e8 92 dd ff ff       	call   80103980 <myproc>
80105bee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bf2:	0f 84 e8 00 00 00    	je     80105ce0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bf8:	e8 83 dd ff ff       	call   80103980 <myproc>
80105bfd:	85 c0                	test   %eax,%eax
80105bff:	74 1d                	je     80105c1e <trap+0xfe>
80105c01:	e8 7a dd ff ff       	call   80103980 <myproc>
80105c06:	8b 40 24             	mov    0x24(%eax),%eax
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	74 11                	je     80105c1e <trap+0xfe>
80105c0d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c11:	83 e0 03             	and    $0x3,%eax
80105c14:	66 83 f8 03          	cmp    $0x3,%ax
80105c18:	0f 84 03 01 00 00    	je     80105d21 <trap+0x201>
    exit();
}
80105c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c21:	5b                   	pop    %ebx
80105c22:	5e                   	pop    %esi
80105c23:	5f                   	pop    %edi
80105c24:	5d                   	pop    %ebp
80105c25:	c3                   	ret    
    ideintr();
80105c26:	e8 b5 c5 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105c2b:	e8 90 cc ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c30:	e8 4b dd ff ff       	call   80103980 <myproc>
80105c35:	85 c0                	test   %eax,%eax
80105c37:	75 8a                	jne    80105bc3 <trap+0xa3>
80105c39:	eb a5                	jmp    80105be0 <trap+0xc0>
    if(cpuid() == 0){
80105c3b:	e8 20 dd ff ff       	call   80103960 <cpuid>
80105c40:	85 c0                	test   %eax,%eax
80105c42:	75 e7                	jne    80105c2b <trap+0x10b>
      acquire(&tickslock);
80105c44:	83 ec 0c             	sub    $0xc,%esp
80105c47:	68 60 4e 12 80       	push   $0x80124e60
80105c4c:	e8 5f ea ff ff       	call   801046b0 <acquire>
      wakeup(&ticks);
80105c51:	c7 04 24 a0 56 12 80 	movl   $0x801256a0,(%esp)
      ticks++;
80105c58:	83 05 a0 56 12 80 01 	addl   $0x1,0x801256a0
      wakeup(&ticks);
80105c5f:	e8 ec e4 ff ff       	call   80104150 <wakeup>
      release(&tickslock);
80105c64:	c7 04 24 60 4e 12 80 	movl   $0x80124e60,(%esp)
80105c6b:	e8 00 eb ff ff       	call   80104770 <release>
80105c70:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c73:	eb b6                	jmp    80105c2b <trap+0x10b>
    kbdintr();
80105c75:	e8 06 cb ff ff       	call   80102780 <kbdintr>
    lapiceoi();
80105c7a:	e8 41 cc ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7f:	e8 fc dc ff ff       	call   80103980 <myproc>
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 85 37 ff ff ff    	jne    80105bc3 <trap+0xa3>
80105c8c:	e9 4f ff ff ff       	jmp    80105be0 <trap+0xc0>
    uartintr();
80105c91:	e8 4a 02 00 00       	call   80105ee0 <uartintr>
    lapiceoi();
80105c96:	e8 25 cc ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9b:	e8 e0 dc ff ff       	call   80103980 <myproc>
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	0f 85 1b ff ff ff    	jne    80105bc3 <trap+0xa3>
80105ca8:	e9 33 ff ff ff       	jmp    80105be0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cad:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cb0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cb4:	e8 a7 dc ff ff       	call   80103960 <cpuid>
80105cb9:	57                   	push   %edi
80105cba:	56                   	push   %esi
80105cbb:	50                   	push   %eax
80105cbc:	68 4c 7a 10 80       	push   $0x80107a4c
80105cc1:	e8 ea a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105cc6:	e8 f5 cb ff ff       	call   801028c0 <lapiceoi>
    break;
80105ccb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cce:	e8 ad dc ff ff       	call   80103980 <myproc>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	0f 85 e8 fe ff ff    	jne    80105bc3 <trap+0xa3>
80105cdb:	e9 00 ff ff ff       	jmp    80105be0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105ce0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ce4:	0f 85 0e ff ff ff    	jne    80105bf8 <trap+0xd8>
    yield();
80105cea:	e8 51 e2 ff ff       	call   80103f40 <yield>
80105cef:	e9 04 ff ff ff       	jmp    80105bf8 <trap+0xd8>
80105cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105cf8:	e8 83 dc ff ff       	call   80103980 <myproc>
80105cfd:	8b 70 24             	mov    0x24(%eax),%esi
80105d00:	85 f6                	test   %esi,%esi
80105d02:	75 3c                	jne    80105d40 <trap+0x220>
    myproc()->tf = tf;
80105d04:	e8 77 dc ff ff       	call   80103980 <myproc>
80105d09:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d0c:	e8 7f ee ff ff       	call   80104b90 <syscall>
    if(myproc()->killed)
80105d11:	e8 6a dc ff ff       	call   80103980 <myproc>
80105d16:	8b 48 24             	mov    0x24(%eax),%ecx
80105d19:	85 c9                	test   %ecx,%ecx
80105d1b:	0f 84 fd fe ff ff    	je     80105c1e <trap+0xfe>
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
      exit();
80105d28:	e9 d3 e0 ff ff       	jmp    80103e00 <exit>
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105d30:	e8 cb e0 ff ff       	call   80103e00 <exit>
80105d35:	e9 a6 fe ff ff       	jmp    80105be0 <trap+0xc0>
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d40:	e8 bb e0 ff ff       	call   80103e00 <exit>
80105d45:	eb bd                	jmp    80105d04 <trap+0x1e4>
80105d47:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d4a:	e8 11 dc ff ff       	call   80103960 <cpuid>
80105d4f:	83 ec 0c             	sub    $0xc,%esp
80105d52:	56                   	push   %esi
80105d53:	57                   	push   %edi
80105d54:	50                   	push   %eax
80105d55:	ff 73 30             	pushl  0x30(%ebx)
80105d58:	68 70 7a 10 80       	push   $0x80107a70
80105d5d:	e8 4e a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105d62:	83 c4 14             	add    $0x14,%esp
80105d65:	68 46 7a 10 80       	push   $0x80107a46
80105d6a:	e8 21 a6 ff ff       	call   80100390 <panic>
80105d6f:	90                   	nop

80105d70 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105d74:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	74 1b                	je     80105d98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d7d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d82:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d83:	a8 01                	test   $0x1,%al
80105d85:	74 11                	je     80105d98 <uartgetc+0x28>
80105d87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d8c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d8d:	0f b6 c0             	movzbl %al,%eax
80105d90:	c3                   	ret    
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d9d:	c3                   	ret    
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <uartputc.part.0>:
uartputc(int c)
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	89 c7                	mov    %eax,%edi
80105da6:	56                   	push   %esi
80105da7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dac:	53                   	push   %ebx
80105dad:	bb 80 00 00 00       	mov    $0x80,%ebx
80105db2:	83 ec 0c             	sub    $0xc,%esp
80105db5:	eb 1b                	jmp    80105dd2 <uartputc.part.0+0x32>
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	6a 0a                	push   $0xa
80105dc5:	e8 16 cb ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	83 eb 01             	sub    $0x1,%ebx
80105dd0:	74 07                	je     80105dd9 <uartputc.part.0+0x39>
80105dd2:	89 f2                	mov    %esi,%edx
80105dd4:	ec                   	in     (%dx),%al
80105dd5:	a8 20                	test   $0x20,%al
80105dd7:	74 e7                	je     80105dc0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dd9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dde:	89 f8                	mov    %edi,%eax
80105de0:	ee                   	out    %al,(%dx)
}
80105de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de4:	5b                   	pop    %ebx
80105de5:	5e                   	pop    %esi
80105de6:	5f                   	pop    %edi
80105de7:	5d                   	pop    %ebp
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <uartinit>:
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	31 c9                	xor    %ecx,%ecx
80105df7:	89 c8                	mov    %ecx,%eax
80105df9:	89 e5                	mov    %esp,%ebp
80105dfb:	57                   	push   %edi
80105dfc:	56                   	push   %esi
80105dfd:	53                   	push   %ebx
80105dfe:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e03:	89 da                	mov    %ebx,%edx
80105e05:	83 ec 0c             	sub    $0xc,%esp
80105e08:	ee                   	out    %al,(%dx)
80105e09:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e0e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e13:	89 fa                	mov    %edi,%edx
80105e15:	ee                   	out    %al,(%dx)
80105e16:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e1b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e20:	ee                   	out    %al,(%dx)
80105e21:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e26:	89 c8                	mov    %ecx,%eax
80105e28:	89 f2                	mov    %esi,%edx
80105e2a:	ee                   	out    %al,(%dx)
80105e2b:	b8 03 00 00 00       	mov    $0x3,%eax
80105e30:	89 fa                	mov    %edi,%edx
80105e32:	ee                   	out    %al,(%dx)
80105e33:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e38:	89 c8                	mov    %ecx,%eax
80105e3a:	ee                   	out    %al,(%dx)
80105e3b:	b8 01 00 00 00       	mov    $0x1,%eax
80105e40:	89 f2                	mov    %esi,%edx
80105e42:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e43:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e48:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e49:	3c ff                	cmp    $0xff,%al
80105e4b:	74 52                	je     80105e9f <uartinit+0xaf>
  uart = 1;
80105e4d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e54:	00 00 00 
80105e57:	89 da                	mov    %ebx,%edx
80105e59:	ec                   	in     (%dx),%al
80105e5a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e5f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e60:	83 ec 08             	sub    $0x8,%esp
80105e63:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105e68:	bb 68 7b 10 80       	mov    $0x80107b68,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e6d:	6a 00                	push   $0x0
80105e6f:	6a 04                	push   $0x4
80105e71:	e8 ba c5 ff ff       	call   80102430 <ioapicenable>
80105e76:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e79:	b8 78 00 00 00       	mov    $0x78,%eax
80105e7e:	eb 04                	jmp    80105e84 <uartinit+0x94>
80105e80:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105e84:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105e8a:	85 d2                	test   %edx,%edx
80105e8c:	74 08                	je     80105e96 <uartinit+0xa6>
    uartputc(*p);
80105e8e:	0f be c0             	movsbl %al,%eax
80105e91:	e8 0a ff ff ff       	call   80105da0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105e96:	89 f0                	mov    %esi,%eax
80105e98:	83 c3 01             	add    $0x1,%ebx
80105e9b:	84 c0                	test   %al,%al
80105e9d:	75 e1                	jne    80105e80 <uartinit+0x90>
}
80105e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea2:	5b                   	pop    %ebx
80105ea3:	5e                   	pop    %esi
80105ea4:	5f                   	pop    %edi
80105ea5:	5d                   	pop    %ebp
80105ea6:	c3                   	ret    
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <uartputc>:
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
  if(!uart)
80105eb5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105ebb:	89 e5                	mov    %esp,%ebp
80105ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ec0:	85 d2                	test   %edx,%edx
80105ec2:	74 0c                	je     80105ed0 <uartputc+0x20>
}
80105ec4:	5d                   	pop    %ebp
80105ec5:	e9 d6 fe ff ff       	jmp    80105da0 <uartputc.part.0>
80105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ed0:	5d                   	pop    %ebp
80105ed1:	c3                   	ret    
80105ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <uartintr>:

void
uartintr(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105eea:	68 70 5d 10 80       	push   $0x80105d70
80105eef:	e8 6c a9 ff ff       	call   80100860 <consoleintr>
}
80105ef4:	83 c4 10             	add    $0x10,%esp
80105ef7:	c9                   	leave  
80105ef8:	c3                   	ret    

80105ef9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $0
80105efb:	6a 00                	push   $0x0
  jmp alltraps
80105efd:	e9 3d fb ff ff       	jmp    80105a3f <alltraps>

80105f02 <vector1>:
.globl vector1
vector1:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $1
80105f04:	6a 01                	push   $0x1
  jmp alltraps
80105f06:	e9 34 fb ff ff       	jmp    80105a3f <alltraps>

80105f0b <vector2>:
.globl vector2
vector2:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $2
80105f0d:	6a 02                	push   $0x2
  jmp alltraps
80105f0f:	e9 2b fb ff ff       	jmp    80105a3f <alltraps>

80105f14 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $3
80105f16:	6a 03                	push   $0x3
  jmp alltraps
80105f18:	e9 22 fb ff ff       	jmp    80105a3f <alltraps>

80105f1d <vector4>:
.globl vector4
vector4:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $4
80105f1f:	6a 04                	push   $0x4
  jmp alltraps
80105f21:	e9 19 fb ff ff       	jmp    80105a3f <alltraps>

80105f26 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $5
80105f28:	6a 05                	push   $0x5
  jmp alltraps
80105f2a:	e9 10 fb ff ff       	jmp    80105a3f <alltraps>

80105f2f <vector6>:
.globl vector6
vector6:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $6
80105f31:	6a 06                	push   $0x6
  jmp alltraps
80105f33:	e9 07 fb ff ff       	jmp    80105a3f <alltraps>

80105f38 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $7
80105f3a:	6a 07                	push   $0x7
  jmp alltraps
80105f3c:	e9 fe fa ff ff       	jmp    80105a3f <alltraps>

80105f41 <vector8>:
.globl vector8
vector8:
  pushl $8
80105f41:	6a 08                	push   $0x8
  jmp alltraps
80105f43:	e9 f7 fa ff ff       	jmp    80105a3f <alltraps>

80105f48 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $9
80105f4a:	6a 09                	push   $0x9
  jmp alltraps
80105f4c:	e9 ee fa ff ff       	jmp    80105a3f <alltraps>

80105f51 <vector10>:
.globl vector10
vector10:
  pushl $10
80105f51:	6a 0a                	push   $0xa
  jmp alltraps
80105f53:	e9 e7 fa ff ff       	jmp    80105a3f <alltraps>

80105f58 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f58:	6a 0b                	push   $0xb
  jmp alltraps
80105f5a:	e9 e0 fa ff ff       	jmp    80105a3f <alltraps>

80105f5f <vector12>:
.globl vector12
vector12:
  pushl $12
80105f5f:	6a 0c                	push   $0xc
  jmp alltraps
80105f61:	e9 d9 fa ff ff       	jmp    80105a3f <alltraps>

80105f66 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f66:	6a 0d                	push   $0xd
  jmp alltraps
80105f68:	e9 d2 fa ff ff       	jmp    80105a3f <alltraps>

80105f6d <vector14>:
.globl vector14
vector14:
  pushl $14
80105f6d:	6a 0e                	push   $0xe
  jmp alltraps
80105f6f:	e9 cb fa ff ff       	jmp    80105a3f <alltraps>

80105f74 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $15
80105f76:	6a 0f                	push   $0xf
  jmp alltraps
80105f78:	e9 c2 fa ff ff       	jmp    80105a3f <alltraps>

80105f7d <vector16>:
.globl vector16
vector16:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $16
80105f7f:	6a 10                	push   $0x10
  jmp alltraps
80105f81:	e9 b9 fa ff ff       	jmp    80105a3f <alltraps>

80105f86 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f86:	6a 11                	push   $0x11
  jmp alltraps
80105f88:	e9 b2 fa ff ff       	jmp    80105a3f <alltraps>

80105f8d <vector18>:
.globl vector18
vector18:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $18
80105f8f:	6a 12                	push   $0x12
  jmp alltraps
80105f91:	e9 a9 fa ff ff       	jmp    80105a3f <alltraps>

80105f96 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $19
80105f98:	6a 13                	push   $0x13
  jmp alltraps
80105f9a:	e9 a0 fa ff ff       	jmp    80105a3f <alltraps>

80105f9f <vector20>:
.globl vector20
vector20:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $20
80105fa1:	6a 14                	push   $0x14
  jmp alltraps
80105fa3:	e9 97 fa ff ff       	jmp    80105a3f <alltraps>

80105fa8 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $21
80105faa:	6a 15                	push   $0x15
  jmp alltraps
80105fac:	e9 8e fa ff ff       	jmp    80105a3f <alltraps>

80105fb1 <vector22>:
.globl vector22
vector22:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $22
80105fb3:	6a 16                	push   $0x16
  jmp alltraps
80105fb5:	e9 85 fa ff ff       	jmp    80105a3f <alltraps>

80105fba <vector23>:
.globl vector23
vector23:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $23
80105fbc:	6a 17                	push   $0x17
  jmp alltraps
80105fbe:	e9 7c fa ff ff       	jmp    80105a3f <alltraps>

80105fc3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $24
80105fc5:	6a 18                	push   $0x18
  jmp alltraps
80105fc7:	e9 73 fa ff ff       	jmp    80105a3f <alltraps>

80105fcc <vector25>:
.globl vector25
vector25:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $25
80105fce:	6a 19                	push   $0x19
  jmp alltraps
80105fd0:	e9 6a fa ff ff       	jmp    80105a3f <alltraps>

80105fd5 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $26
80105fd7:	6a 1a                	push   $0x1a
  jmp alltraps
80105fd9:	e9 61 fa ff ff       	jmp    80105a3f <alltraps>

80105fde <vector27>:
.globl vector27
vector27:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $27
80105fe0:	6a 1b                	push   $0x1b
  jmp alltraps
80105fe2:	e9 58 fa ff ff       	jmp    80105a3f <alltraps>

80105fe7 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $28
80105fe9:	6a 1c                	push   $0x1c
  jmp alltraps
80105feb:	e9 4f fa ff ff       	jmp    80105a3f <alltraps>

80105ff0 <vector29>:
.globl vector29
vector29:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $29
80105ff2:	6a 1d                	push   $0x1d
  jmp alltraps
80105ff4:	e9 46 fa ff ff       	jmp    80105a3f <alltraps>

80105ff9 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $30
80105ffb:	6a 1e                	push   $0x1e
  jmp alltraps
80105ffd:	e9 3d fa ff ff       	jmp    80105a3f <alltraps>

80106002 <vector31>:
.globl vector31
vector31:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $31
80106004:	6a 1f                	push   $0x1f
  jmp alltraps
80106006:	e9 34 fa ff ff       	jmp    80105a3f <alltraps>

8010600b <vector32>:
.globl vector32
vector32:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $32
8010600d:	6a 20                	push   $0x20
  jmp alltraps
8010600f:	e9 2b fa ff ff       	jmp    80105a3f <alltraps>

80106014 <vector33>:
.globl vector33
vector33:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $33
80106016:	6a 21                	push   $0x21
  jmp alltraps
80106018:	e9 22 fa ff ff       	jmp    80105a3f <alltraps>

8010601d <vector34>:
.globl vector34
vector34:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $34
8010601f:	6a 22                	push   $0x22
  jmp alltraps
80106021:	e9 19 fa ff ff       	jmp    80105a3f <alltraps>

80106026 <vector35>:
.globl vector35
vector35:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $35
80106028:	6a 23                	push   $0x23
  jmp alltraps
8010602a:	e9 10 fa ff ff       	jmp    80105a3f <alltraps>

8010602f <vector36>:
.globl vector36
vector36:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $36
80106031:	6a 24                	push   $0x24
  jmp alltraps
80106033:	e9 07 fa ff ff       	jmp    80105a3f <alltraps>

80106038 <vector37>:
.globl vector37
vector37:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $37
8010603a:	6a 25                	push   $0x25
  jmp alltraps
8010603c:	e9 fe f9 ff ff       	jmp    80105a3f <alltraps>

80106041 <vector38>:
.globl vector38
vector38:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $38
80106043:	6a 26                	push   $0x26
  jmp alltraps
80106045:	e9 f5 f9 ff ff       	jmp    80105a3f <alltraps>

8010604a <vector39>:
.globl vector39
vector39:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $39
8010604c:	6a 27                	push   $0x27
  jmp alltraps
8010604e:	e9 ec f9 ff ff       	jmp    80105a3f <alltraps>

80106053 <vector40>:
.globl vector40
vector40:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $40
80106055:	6a 28                	push   $0x28
  jmp alltraps
80106057:	e9 e3 f9 ff ff       	jmp    80105a3f <alltraps>

8010605c <vector41>:
.globl vector41
vector41:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $41
8010605e:	6a 29                	push   $0x29
  jmp alltraps
80106060:	e9 da f9 ff ff       	jmp    80105a3f <alltraps>

80106065 <vector42>:
.globl vector42
vector42:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $42
80106067:	6a 2a                	push   $0x2a
  jmp alltraps
80106069:	e9 d1 f9 ff ff       	jmp    80105a3f <alltraps>

8010606e <vector43>:
.globl vector43
vector43:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $43
80106070:	6a 2b                	push   $0x2b
  jmp alltraps
80106072:	e9 c8 f9 ff ff       	jmp    80105a3f <alltraps>

80106077 <vector44>:
.globl vector44
vector44:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $44
80106079:	6a 2c                	push   $0x2c
  jmp alltraps
8010607b:	e9 bf f9 ff ff       	jmp    80105a3f <alltraps>

80106080 <vector45>:
.globl vector45
vector45:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $45
80106082:	6a 2d                	push   $0x2d
  jmp alltraps
80106084:	e9 b6 f9 ff ff       	jmp    80105a3f <alltraps>

80106089 <vector46>:
.globl vector46
vector46:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $46
8010608b:	6a 2e                	push   $0x2e
  jmp alltraps
8010608d:	e9 ad f9 ff ff       	jmp    80105a3f <alltraps>

80106092 <vector47>:
.globl vector47
vector47:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $47
80106094:	6a 2f                	push   $0x2f
  jmp alltraps
80106096:	e9 a4 f9 ff ff       	jmp    80105a3f <alltraps>

8010609b <vector48>:
.globl vector48
vector48:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $48
8010609d:	6a 30                	push   $0x30
  jmp alltraps
8010609f:	e9 9b f9 ff ff       	jmp    80105a3f <alltraps>

801060a4 <vector49>:
.globl vector49
vector49:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $49
801060a6:	6a 31                	push   $0x31
  jmp alltraps
801060a8:	e9 92 f9 ff ff       	jmp    80105a3f <alltraps>

801060ad <vector50>:
.globl vector50
vector50:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $50
801060af:	6a 32                	push   $0x32
  jmp alltraps
801060b1:	e9 89 f9 ff ff       	jmp    80105a3f <alltraps>

801060b6 <vector51>:
.globl vector51
vector51:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $51
801060b8:	6a 33                	push   $0x33
  jmp alltraps
801060ba:	e9 80 f9 ff ff       	jmp    80105a3f <alltraps>

801060bf <vector52>:
.globl vector52
vector52:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $52
801060c1:	6a 34                	push   $0x34
  jmp alltraps
801060c3:	e9 77 f9 ff ff       	jmp    80105a3f <alltraps>

801060c8 <vector53>:
.globl vector53
vector53:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $53
801060ca:	6a 35                	push   $0x35
  jmp alltraps
801060cc:	e9 6e f9 ff ff       	jmp    80105a3f <alltraps>

801060d1 <vector54>:
.globl vector54
vector54:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $54
801060d3:	6a 36                	push   $0x36
  jmp alltraps
801060d5:	e9 65 f9 ff ff       	jmp    80105a3f <alltraps>

801060da <vector55>:
.globl vector55
vector55:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $55
801060dc:	6a 37                	push   $0x37
  jmp alltraps
801060de:	e9 5c f9 ff ff       	jmp    80105a3f <alltraps>

801060e3 <vector56>:
.globl vector56
vector56:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $56
801060e5:	6a 38                	push   $0x38
  jmp alltraps
801060e7:	e9 53 f9 ff ff       	jmp    80105a3f <alltraps>

801060ec <vector57>:
.globl vector57
vector57:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $57
801060ee:	6a 39                	push   $0x39
  jmp alltraps
801060f0:	e9 4a f9 ff ff       	jmp    80105a3f <alltraps>

801060f5 <vector58>:
.globl vector58
vector58:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $58
801060f7:	6a 3a                	push   $0x3a
  jmp alltraps
801060f9:	e9 41 f9 ff ff       	jmp    80105a3f <alltraps>

801060fe <vector59>:
.globl vector59
vector59:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $59
80106100:	6a 3b                	push   $0x3b
  jmp alltraps
80106102:	e9 38 f9 ff ff       	jmp    80105a3f <alltraps>

80106107 <vector60>:
.globl vector60
vector60:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $60
80106109:	6a 3c                	push   $0x3c
  jmp alltraps
8010610b:	e9 2f f9 ff ff       	jmp    80105a3f <alltraps>

80106110 <vector61>:
.globl vector61
vector61:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $61
80106112:	6a 3d                	push   $0x3d
  jmp alltraps
80106114:	e9 26 f9 ff ff       	jmp    80105a3f <alltraps>

80106119 <vector62>:
.globl vector62
vector62:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $62
8010611b:	6a 3e                	push   $0x3e
  jmp alltraps
8010611d:	e9 1d f9 ff ff       	jmp    80105a3f <alltraps>

80106122 <vector63>:
.globl vector63
vector63:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $63
80106124:	6a 3f                	push   $0x3f
  jmp alltraps
80106126:	e9 14 f9 ff ff       	jmp    80105a3f <alltraps>

8010612b <vector64>:
.globl vector64
vector64:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $64
8010612d:	6a 40                	push   $0x40
  jmp alltraps
8010612f:	e9 0b f9 ff ff       	jmp    80105a3f <alltraps>

80106134 <vector65>:
.globl vector65
vector65:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $65
80106136:	6a 41                	push   $0x41
  jmp alltraps
80106138:	e9 02 f9 ff ff       	jmp    80105a3f <alltraps>

8010613d <vector66>:
.globl vector66
vector66:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $66
8010613f:	6a 42                	push   $0x42
  jmp alltraps
80106141:	e9 f9 f8 ff ff       	jmp    80105a3f <alltraps>

80106146 <vector67>:
.globl vector67
vector67:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $67
80106148:	6a 43                	push   $0x43
  jmp alltraps
8010614a:	e9 f0 f8 ff ff       	jmp    80105a3f <alltraps>

8010614f <vector68>:
.globl vector68
vector68:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $68
80106151:	6a 44                	push   $0x44
  jmp alltraps
80106153:	e9 e7 f8 ff ff       	jmp    80105a3f <alltraps>

80106158 <vector69>:
.globl vector69
vector69:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $69
8010615a:	6a 45                	push   $0x45
  jmp alltraps
8010615c:	e9 de f8 ff ff       	jmp    80105a3f <alltraps>

80106161 <vector70>:
.globl vector70
vector70:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $70
80106163:	6a 46                	push   $0x46
  jmp alltraps
80106165:	e9 d5 f8 ff ff       	jmp    80105a3f <alltraps>

8010616a <vector71>:
.globl vector71
vector71:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $71
8010616c:	6a 47                	push   $0x47
  jmp alltraps
8010616e:	e9 cc f8 ff ff       	jmp    80105a3f <alltraps>

80106173 <vector72>:
.globl vector72
vector72:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $72
80106175:	6a 48                	push   $0x48
  jmp alltraps
80106177:	e9 c3 f8 ff ff       	jmp    80105a3f <alltraps>

8010617c <vector73>:
.globl vector73
vector73:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $73
8010617e:	6a 49                	push   $0x49
  jmp alltraps
80106180:	e9 ba f8 ff ff       	jmp    80105a3f <alltraps>

80106185 <vector74>:
.globl vector74
vector74:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $74
80106187:	6a 4a                	push   $0x4a
  jmp alltraps
80106189:	e9 b1 f8 ff ff       	jmp    80105a3f <alltraps>

8010618e <vector75>:
.globl vector75
vector75:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $75
80106190:	6a 4b                	push   $0x4b
  jmp alltraps
80106192:	e9 a8 f8 ff ff       	jmp    80105a3f <alltraps>

80106197 <vector76>:
.globl vector76
vector76:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $76
80106199:	6a 4c                	push   $0x4c
  jmp alltraps
8010619b:	e9 9f f8 ff ff       	jmp    80105a3f <alltraps>

801061a0 <vector77>:
.globl vector77
vector77:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $77
801061a2:	6a 4d                	push   $0x4d
  jmp alltraps
801061a4:	e9 96 f8 ff ff       	jmp    80105a3f <alltraps>

801061a9 <vector78>:
.globl vector78
vector78:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $78
801061ab:	6a 4e                	push   $0x4e
  jmp alltraps
801061ad:	e9 8d f8 ff ff       	jmp    80105a3f <alltraps>

801061b2 <vector79>:
.globl vector79
vector79:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $79
801061b4:	6a 4f                	push   $0x4f
  jmp alltraps
801061b6:	e9 84 f8 ff ff       	jmp    80105a3f <alltraps>

801061bb <vector80>:
.globl vector80
vector80:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $80
801061bd:	6a 50                	push   $0x50
  jmp alltraps
801061bf:	e9 7b f8 ff ff       	jmp    80105a3f <alltraps>

801061c4 <vector81>:
.globl vector81
vector81:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $81
801061c6:	6a 51                	push   $0x51
  jmp alltraps
801061c8:	e9 72 f8 ff ff       	jmp    80105a3f <alltraps>

801061cd <vector82>:
.globl vector82
vector82:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $82
801061cf:	6a 52                	push   $0x52
  jmp alltraps
801061d1:	e9 69 f8 ff ff       	jmp    80105a3f <alltraps>

801061d6 <vector83>:
.globl vector83
vector83:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $83
801061d8:	6a 53                	push   $0x53
  jmp alltraps
801061da:	e9 60 f8 ff ff       	jmp    80105a3f <alltraps>

801061df <vector84>:
.globl vector84
vector84:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $84
801061e1:	6a 54                	push   $0x54
  jmp alltraps
801061e3:	e9 57 f8 ff ff       	jmp    80105a3f <alltraps>

801061e8 <vector85>:
.globl vector85
vector85:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $85
801061ea:	6a 55                	push   $0x55
  jmp alltraps
801061ec:	e9 4e f8 ff ff       	jmp    80105a3f <alltraps>

801061f1 <vector86>:
.globl vector86
vector86:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $86
801061f3:	6a 56                	push   $0x56
  jmp alltraps
801061f5:	e9 45 f8 ff ff       	jmp    80105a3f <alltraps>

801061fa <vector87>:
.globl vector87
vector87:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $87
801061fc:	6a 57                	push   $0x57
  jmp alltraps
801061fe:	e9 3c f8 ff ff       	jmp    80105a3f <alltraps>

80106203 <vector88>:
.globl vector88
vector88:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $88
80106205:	6a 58                	push   $0x58
  jmp alltraps
80106207:	e9 33 f8 ff ff       	jmp    80105a3f <alltraps>

8010620c <vector89>:
.globl vector89
vector89:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $89
8010620e:	6a 59                	push   $0x59
  jmp alltraps
80106210:	e9 2a f8 ff ff       	jmp    80105a3f <alltraps>

80106215 <vector90>:
.globl vector90
vector90:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $90
80106217:	6a 5a                	push   $0x5a
  jmp alltraps
80106219:	e9 21 f8 ff ff       	jmp    80105a3f <alltraps>

8010621e <vector91>:
.globl vector91
vector91:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $91
80106220:	6a 5b                	push   $0x5b
  jmp alltraps
80106222:	e9 18 f8 ff ff       	jmp    80105a3f <alltraps>

80106227 <vector92>:
.globl vector92
vector92:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $92
80106229:	6a 5c                	push   $0x5c
  jmp alltraps
8010622b:	e9 0f f8 ff ff       	jmp    80105a3f <alltraps>

80106230 <vector93>:
.globl vector93
vector93:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $93
80106232:	6a 5d                	push   $0x5d
  jmp alltraps
80106234:	e9 06 f8 ff ff       	jmp    80105a3f <alltraps>

80106239 <vector94>:
.globl vector94
vector94:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $94
8010623b:	6a 5e                	push   $0x5e
  jmp alltraps
8010623d:	e9 fd f7 ff ff       	jmp    80105a3f <alltraps>

80106242 <vector95>:
.globl vector95
vector95:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $95
80106244:	6a 5f                	push   $0x5f
  jmp alltraps
80106246:	e9 f4 f7 ff ff       	jmp    80105a3f <alltraps>

8010624b <vector96>:
.globl vector96
vector96:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $96
8010624d:	6a 60                	push   $0x60
  jmp alltraps
8010624f:	e9 eb f7 ff ff       	jmp    80105a3f <alltraps>

80106254 <vector97>:
.globl vector97
vector97:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $97
80106256:	6a 61                	push   $0x61
  jmp alltraps
80106258:	e9 e2 f7 ff ff       	jmp    80105a3f <alltraps>

8010625d <vector98>:
.globl vector98
vector98:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $98
8010625f:	6a 62                	push   $0x62
  jmp alltraps
80106261:	e9 d9 f7 ff ff       	jmp    80105a3f <alltraps>

80106266 <vector99>:
.globl vector99
vector99:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $99
80106268:	6a 63                	push   $0x63
  jmp alltraps
8010626a:	e9 d0 f7 ff ff       	jmp    80105a3f <alltraps>

8010626f <vector100>:
.globl vector100
vector100:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $100
80106271:	6a 64                	push   $0x64
  jmp alltraps
80106273:	e9 c7 f7 ff ff       	jmp    80105a3f <alltraps>

80106278 <vector101>:
.globl vector101
vector101:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $101
8010627a:	6a 65                	push   $0x65
  jmp alltraps
8010627c:	e9 be f7 ff ff       	jmp    80105a3f <alltraps>

80106281 <vector102>:
.globl vector102
vector102:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $102
80106283:	6a 66                	push   $0x66
  jmp alltraps
80106285:	e9 b5 f7 ff ff       	jmp    80105a3f <alltraps>

8010628a <vector103>:
.globl vector103
vector103:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $103
8010628c:	6a 67                	push   $0x67
  jmp alltraps
8010628e:	e9 ac f7 ff ff       	jmp    80105a3f <alltraps>

80106293 <vector104>:
.globl vector104
vector104:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $104
80106295:	6a 68                	push   $0x68
  jmp alltraps
80106297:	e9 a3 f7 ff ff       	jmp    80105a3f <alltraps>

8010629c <vector105>:
.globl vector105
vector105:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $105
8010629e:	6a 69                	push   $0x69
  jmp alltraps
801062a0:	e9 9a f7 ff ff       	jmp    80105a3f <alltraps>

801062a5 <vector106>:
.globl vector106
vector106:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $106
801062a7:	6a 6a                	push   $0x6a
  jmp alltraps
801062a9:	e9 91 f7 ff ff       	jmp    80105a3f <alltraps>

801062ae <vector107>:
.globl vector107
vector107:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $107
801062b0:	6a 6b                	push   $0x6b
  jmp alltraps
801062b2:	e9 88 f7 ff ff       	jmp    80105a3f <alltraps>

801062b7 <vector108>:
.globl vector108
vector108:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $108
801062b9:	6a 6c                	push   $0x6c
  jmp alltraps
801062bb:	e9 7f f7 ff ff       	jmp    80105a3f <alltraps>

801062c0 <vector109>:
.globl vector109
vector109:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $109
801062c2:	6a 6d                	push   $0x6d
  jmp alltraps
801062c4:	e9 76 f7 ff ff       	jmp    80105a3f <alltraps>

801062c9 <vector110>:
.globl vector110
vector110:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $110
801062cb:	6a 6e                	push   $0x6e
  jmp alltraps
801062cd:	e9 6d f7 ff ff       	jmp    80105a3f <alltraps>

801062d2 <vector111>:
.globl vector111
vector111:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $111
801062d4:	6a 6f                	push   $0x6f
  jmp alltraps
801062d6:	e9 64 f7 ff ff       	jmp    80105a3f <alltraps>

801062db <vector112>:
.globl vector112
vector112:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $112
801062dd:	6a 70                	push   $0x70
  jmp alltraps
801062df:	e9 5b f7 ff ff       	jmp    80105a3f <alltraps>

801062e4 <vector113>:
.globl vector113
vector113:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $113
801062e6:	6a 71                	push   $0x71
  jmp alltraps
801062e8:	e9 52 f7 ff ff       	jmp    80105a3f <alltraps>

801062ed <vector114>:
.globl vector114
vector114:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $114
801062ef:	6a 72                	push   $0x72
  jmp alltraps
801062f1:	e9 49 f7 ff ff       	jmp    80105a3f <alltraps>

801062f6 <vector115>:
.globl vector115
vector115:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $115
801062f8:	6a 73                	push   $0x73
  jmp alltraps
801062fa:	e9 40 f7 ff ff       	jmp    80105a3f <alltraps>

801062ff <vector116>:
.globl vector116
vector116:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $116
80106301:	6a 74                	push   $0x74
  jmp alltraps
80106303:	e9 37 f7 ff ff       	jmp    80105a3f <alltraps>

80106308 <vector117>:
.globl vector117
vector117:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $117
8010630a:	6a 75                	push   $0x75
  jmp alltraps
8010630c:	e9 2e f7 ff ff       	jmp    80105a3f <alltraps>

80106311 <vector118>:
.globl vector118
vector118:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $118
80106313:	6a 76                	push   $0x76
  jmp alltraps
80106315:	e9 25 f7 ff ff       	jmp    80105a3f <alltraps>

8010631a <vector119>:
.globl vector119
vector119:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $119
8010631c:	6a 77                	push   $0x77
  jmp alltraps
8010631e:	e9 1c f7 ff ff       	jmp    80105a3f <alltraps>

80106323 <vector120>:
.globl vector120
vector120:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $120
80106325:	6a 78                	push   $0x78
  jmp alltraps
80106327:	e9 13 f7 ff ff       	jmp    80105a3f <alltraps>

8010632c <vector121>:
.globl vector121
vector121:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $121
8010632e:	6a 79                	push   $0x79
  jmp alltraps
80106330:	e9 0a f7 ff ff       	jmp    80105a3f <alltraps>

80106335 <vector122>:
.globl vector122
vector122:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $122
80106337:	6a 7a                	push   $0x7a
  jmp alltraps
80106339:	e9 01 f7 ff ff       	jmp    80105a3f <alltraps>

8010633e <vector123>:
.globl vector123
vector123:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $123
80106340:	6a 7b                	push   $0x7b
  jmp alltraps
80106342:	e9 f8 f6 ff ff       	jmp    80105a3f <alltraps>

80106347 <vector124>:
.globl vector124
vector124:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $124
80106349:	6a 7c                	push   $0x7c
  jmp alltraps
8010634b:	e9 ef f6 ff ff       	jmp    80105a3f <alltraps>

80106350 <vector125>:
.globl vector125
vector125:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $125
80106352:	6a 7d                	push   $0x7d
  jmp alltraps
80106354:	e9 e6 f6 ff ff       	jmp    80105a3f <alltraps>

80106359 <vector126>:
.globl vector126
vector126:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $126
8010635b:	6a 7e                	push   $0x7e
  jmp alltraps
8010635d:	e9 dd f6 ff ff       	jmp    80105a3f <alltraps>

80106362 <vector127>:
.globl vector127
vector127:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $127
80106364:	6a 7f                	push   $0x7f
  jmp alltraps
80106366:	e9 d4 f6 ff ff       	jmp    80105a3f <alltraps>

8010636b <vector128>:
.globl vector128
vector128:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $128
8010636d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106372:	e9 c8 f6 ff ff       	jmp    80105a3f <alltraps>

80106377 <vector129>:
.globl vector129
vector129:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $129
80106379:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010637e:	e9 bc f6 ff ff       	jmp    80105a3f <alltraps>

80106383 <vector130>:
.globl vector130
vector130:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $130
80106385:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010638a:	e9 b0 f6 ff ff       	jmp    80105a3f <alltraps>

8010638f <vector131>:
.globl vector131
vector131:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $131
80106391:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106396:	e9 a4 f6 ff ff       	jmp    80105a3f <alltraps>

8010639b <vector132>:
.globl vector132
vector132:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $132
8010639d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063a2:	e9 98 f6 ff ff       	jmp    80105a3f <alltraps>

801063a7 <vector133>:
.globl vector133
vector133:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $133
801063a9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063ae:	e9 8c f6 ff ff       	jmp    80105a3f <alltraps>

801063b3 <vector134>:
.globl vector134
vector134:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $134
801063b5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063ba:	e9 80 f6 ff ff       	jmp    80105a3f <alltraps>

801063bf <vector135>:
.globl vector135
vector135:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $135
801063c1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063c6:	e9 74 f6 ff ff       	jmp    80105a3f <alltraps>

801063cb <vector136>:
.globl vector136
vector136:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $136
801063cd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063d2:	e9 68 f6 ff ff       	jmp    80105a3f <alltraps>

801063d7 <vector137>:
.globl vector137
vector137:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $137
801063d9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063de:	e9 5c f6 ff ff       	jmp    80105a3f <alltraps>

801063e3 <vector138>:
.globl vector138
vector138:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $138
801063e5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063ea:	e9 50 f6 ff ff       	jmp    80105a3f <alltraps>

801063ef <vector139>:
.globl vector139
vector139:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $139
801063f1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063f6:	e9 44 f6 ff ff       	jmp    80105a3f <alltraps>

801063fb <vector140>:
.globl vector140
vector140:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $140
801063fd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106402:	e9 38 f6 ff ff       	jmp    80105a3f <alltraps>

80106407 <vector141>:
.globl vector141
vector141:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $141
80106409:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010640e:	e9 2c f6 ff ff       	jmp    80105a3f <alltraps>

80106413 <vector142>:
.globl vector142
vector142:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $142
80106415:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010641a:	e9 20 f6 ff ff       	jmp    80105a3f <alltraps>

8010641f <vector143>:
.globl vector143
vector143:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $143
80106421:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106426:	e9 14 f6 ff ff       	jmp    80105a3f <alltraps>

8010642b <vector144>:
.globl vector144
vector144:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $144
8010642d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106432:	e9 08 f6 ff ff       	jmp    80105a3f <alltraps>

80106437 <vector145>:
.globl vector145
vector145:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $145
80106439:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010643e:	e9 fc f5 ff ff       	jmp    80105a3f <alltraps>

80106443 <vector146>:
.globl vector146
vector146:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $146
80106445:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010644a:	e9 f0 f5 ff ff       	jmp    80105a3f <alltraps>

8010644f <vector147>:
.globl vector147
vector147:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $147
80106451:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106456:	e9 e4 f5 ff ff       	jmp    80105a3f <alltraps>

8010645b <vector148>:
.globl vector148
vector148:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $148
8010645d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106462:	e9 d8 f5 ff ff       	jmp    80105a3f <alltraps>

80106467 <vector149>:
.globl vector149
vector149:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $149
80106469:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010646e:	e9 cc f5 ff ff       	jmp    80105a3f <alltraps>

80106473 <vector150>:
.globl vector150
vector150:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $150
80106475:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010647a:	e9 c0 f5 ff ff       	jmp    80105a3f <alltraps>

8010647f <vector151>:
.globl vector151
vector151:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $151
80106481:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106486:	e9 b4 f5 ff ff       	jmp    80105a3f <alltraps>

8010648b <vector152>:
.globl vector152
vector152:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $152
8010648d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106492:	e9 a8 f5 ff ff       	jmp    80105a3f <alltraps>

80106497 <vector153>:
.globl vector153
vector153:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $153
80106499:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010649e:	e9 9c f5 ff ff       	jmp    80105a3f <alltraps>

801064a3 <vector154>:
.globl vector154
vector154:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $154
801064a5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064aa:	e9 90 f5 ff ff       	jmp    80105a3f <alltraps>

801064af <vector155>:
.globl vector155
vector155:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $155
801064b1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064b6:	e9 84 f5 ff ff       	jmp    80105a3f <alltraps>

801064bb <vector156>:
.globl vector156
vector156:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $156
801064bd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064c2:	e9 78 f5 ff ff       	jmp    80105a3f <alltraps>

801064c7 <vector157>:
.globl vector157
vector157:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $157
801064c9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064ce:	e9 6c f5 ff ff       	jmp    80105a3f <alltraps>

801064d3 <vector158>:
.globl vector158
vector158:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $158
801064d5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064da:	e9 60 f5 ff ff       	jmp    80105a3f <alltraps>

801064df <vector159>:
.globl vector159
vector159:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $159
801064e1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064e6:	e9 54 f5 ff ff       	jmp    80105a3f <alltraps>

801064eb <vector160>:
.globl vector160
vector160:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $160
801064ed:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064f2:	e9 48 f5 ff ff       	jmp    80105a3f <alltraps>

801064f7 <vector161>:
.globl vector161
vector161:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $161
801064f9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064fe:	e9 3c f5 ff ff       	jmp    80105a3f <alltraps>

80106503 <vector162>:
.globl vector162
vector162:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $162
80106505:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010650a:	e9 30 f5 ff ff       	jmp    80105a3f <alltraps>

8010650f <vector163>:
.globl vector163
vector163:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $163
80106511:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106516:	e9 24 f5 ff ff       	jmp    80105a3f <alltraps>

8010651b <vector164>:
.globl vector164
vector164:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $164
8010651d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106522:	e9 18 f5 ff ff       	jmp    80105a3f <alltraps>

80106527 <vector165>:
.globl vector165
vector165:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $165
80106529:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010652e:	e9 0c f5 ff ff       	jmp    80105a3f <alltraps>

80106533 <vector166>:
.globl vector166
vector166:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $166
80106535:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010653a:	e9 00 f5 ff ff       	jmp    80105a3f <alltraps>

8010653f <vector167>:
.globl vector167
vector167:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $167
80106541:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106546:	e9 f4 f4 ff ff       	jmp    80105a3f <alltraps>

8010654b <vector168>:
.globl vector168
vector168:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $168
8010654d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106552:	e9 e8 f4 ff ff       	jmp    80105a3f <alltraps>

80106557 <vector169>:
.globl vector169
vector169:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $169
80106559:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010655e:	e9 dc f4 ff ff       	jmp    80105a3f <alltraps>

80106563 <vector170>:
.globl vector170
vector170:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $170
80106565:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010656a:	e9 d0 f4 ff ff       	jmp    80105a3f <alltraps>

8010656f <vector171>:
.globl vector171
vector171:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $171
80106571:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106576:	e9 c4 f4 ff ff       	jmp    80105a3f <alltraps>

8010657b <vector172>:
.globl vector172
vector172:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $172
8010657d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106582:	e9 b8 f4 ff ff       	jmp    80105a3f <alltraps>

80106587 <vector173>:
.globl vector173
vector173:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $173
80106589:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010658e:	e9 ac f4 ff ff       	jmp    80105a3f <alltraps>

80106593 <vector174>:
.globl vector174
vector174:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $174
80106595:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010659a:	e9 a0 f4 ff ff       	jmp    80105a3f <alltraps>

8010659f <vector175>:
.globl vector175
vector175:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $175
801065a1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065a6:	e9 94 f4 ff ff       	jmp    80105a3f <alltraps>

801065ab <vector176>:
.globl vector176
vector176:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $176
801065ad:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065b2:	e9 88 f4 ff ff       	jmp    80105a3f <alltraps>

801065b7 <vector177>:
.globl vector177
vector177:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $177
801065b9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065be:	e9 7c f4 ff ff       	jmp    80105a3f <alltraps>

801065c3 <vector178>:
.globl vector178
vector178:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $178
801065c5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065ca:	e9 70 f4 ff ff       	jmp    80105a3f <alltraps>

801065cf <vector179>:
.globl vector179
vector179:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $179
801065d1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065d6:	e9 64 f4 ff ff       	jmp    80105a3f <alltraps>

801065db <vector180>:
.globl vector180
vector180:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $180
801065dd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065e2:	e9 58 f4 ff ff       	jmp    80105a3f <alltraps>

801065e7 <vector181>:
.globl vector181
vector181:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $181
801065e9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065ee:	e9 4c f4 ff ff       	jmp    80105a3f <alltraps>

801065f3 <vector182>:
.globl vector182
vector182:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $182
801065f5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065fa:	e9 40 f4 ff ff       	jmp    80105a3f <alltraps>

801065ff <vector183>:
.globl vector183
vector183:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $183
80106601:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106606:	e9 34 f4 ff ff       	jmp    80105a3f <alltraps>

8010660b <vector184>:
.globl vector184
vector184:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $184
8010660d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106612:	e9 28 f4 ff ff       	jmp    80105a3f <alltraps>

80106617 <vector185>:
.globl vector185
vector185:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $185
80106619:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010661e:	e9 1c f4 ff ff       	jmp    80105a3f <alltraps>

80106623 <vector186>:
.globl vector186
vector186:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $186
80106625:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010662a:	e9 10 f4 ff ff       	jmp    80105a3f <alltraps>

8010662f <vector187>:
.globl vector187
vector187:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $187
80106631:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106636:	e9 04 f4 ff ff       	jmp    80105a3f <alltraps>

8010663b <vector188>:
.globl vector188
vector188:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $188
8010663d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106642:	e9 f8 f3 ff ff       	jmp    80105a3f <alltraps>

80106647 <vector189>:
.globl vector189
vector189:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $189
80106649:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010664e:	e9 ec f3 ff ff       	jmp    80105a3f <alltraps>

80106653 <vector190>:
.globl vector190
vector190:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $190
80106655:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010665a:	e9 e0 f3 ff ff       	jmp    80105a3f <alltraps>

8010665f <vector191>:
.globl vector191
vector191:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $191
80106661:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106666:	e9 d4 f3 ff ff       	jmp    80105a3f <alltraps>

8010666b <vector192>:
.globl vector192
vector192:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $192
8010666d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106672:	e9 c8 f3 ff ff       	jmp    80105a3f <alltraps>

80106677 <vector193>:
.globl vector193
vector193:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $193
80106679:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010667e:	e9 bc f3 ff ff       	jmp    80105a3f <alltraps>

80106683 <vector194>:
.globl vector194
vector194:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $194
80106685:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010668a:	e9 b0 f3 ff ff       	jmp    80105a3f <alltraps>

8010668f <vector195>:
.globl vector195
vector195:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $195
80106691:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106696:	e9 a4 f3 ff ff       	jmp    80105a3f <alltraps>

8010669b <vector196>:
.globl vector196
vector196:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $196
8010669d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066a2:	e9 98 f3 ff ff       	jmp    80105a3f <alltraps>

801066a7 <vector197>:
.globl vector197
vector197:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $197
801066a9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066ae:	e9 8c f3 ff ff       	jmp    80105a3f <alltraps>

801066b3 <vector198>:
.globl vector198
vector198:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $198
801066b5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066ba:	e9 80 f3 ff ff       	jmp    80105a3f <alltraps>

801066bf <vector199>:
.globl vector199
vector199:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $199
801066c1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066c6:	e9 74 f3 ff ff       	jmp    80105a3f <alltraps>

801066cb <vector200>:
.globl vector200
vector200:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $200
801066cd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066d2:	e9 68 f3 ff ff       	jmp    80105a3f <alltraps>

801066d7 <vector201>:
.globl vector201
vector201:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $201
801066d9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066de:	e9 5c f3 ff ff       	jmp    80105a3f <alltraps>

801066e3 <vector202>:
.globl vector202
vector202:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $202
801066e5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066ea:	e9 50 f3 ff ff       	jmp    80105a3f <alltraps>

801066ef <vector203>:
.globl vector203
vector203:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $203
801066f1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066f6:	e9 44 f3 ff ff       	jmp    80105a3f <alltraps>

801066fb <vector204>:
.globl vector204
vector204:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $204
801066fd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106702:	e9 38 f3 ff ff       	jmp    80105a3f <alltraps>

80106707 <vector205>:
.globl vector205
vector205:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $205
80106709:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010670e:	e9 2c f3 ff ff       	jmp    80105a3f <alltraps>

80106713 <vector206>:
.globl vector206
vector206:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $206
80106715:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010671a:	e9 20 f3 ff ff       	jmp    80105a3f <alltraps>

8010671f <vector207>:
.globl vector207
vector207:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $207
80106721:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106726:	e9 14 f3 ff ff       	jmp    80105a3f <alltraps>

8010672b <vector208>:
.globl vector208
vector208:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $208
8010672d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106732:	e9 08 f3 ff ff       	jmp    80105a3f <alltraps>

80106737 <vector209>:
.globl vector209
vector209:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $209
80106739:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010673e:	e9 fc f2 ff ff       	jmp    80105a3f <alltraps>

80106743 <vector210>:
.globl vector210
vector210:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $210
80106745:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010674a:	e9 f0 f2 ff ff       	jmp    80105a3f <alltraps>

8010674f <vector211>:
.globl vector211
vector211:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $211
80106751:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106756:	e9 e4 f2 ff ff       	jmp    80105a3f <alltraps>

8010675b <vector212>:
.globl vector212
vector212:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $212
8010675d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106762:	e9 d8 f2 ff ff       	jmp    80105a3f <alltraps>

80106767 <vector213>:
.globl vector213
vector213:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $213
80106769:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010676e:	e9 cc f2 ff ff       	jmp    80105a3f <alltraps>

80106773 <vector214>:
.globl vector214
vector214:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $214
80106775:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010677a:	e9 c0 f2 ff ff       	jmp    80105a3f <alltraps>

8010677f <vector215>:
.globl vector215
vector215:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $215
80106781:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106786:	e9 b4 f2 ff ff       	jmp    80105a3f <alltraps>

8010678b <vector216>:
.globl vector216
vector216:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $216
8010678d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106792:	e9 a8 f2 ff ff       	jmp    80105a3f <alltraps>

80106797 <vector217>:
.globl vector217
vector217:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $217
80106799:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010679e:	e9 9c f2 ff ff       	jmp    80105a3f <alltraps>

801067a3 <vector218>:
.globl vector218
vector218:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $218
801067a5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067aa:	e9 90 f2 ff ff       	jmp    80105a3f <alltraps>

801067af <vector219>:
.globl vector219
vector219:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $219
801067b1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067b6:	e9 84 f2 ff ff       	jmp    80105a3f <alltraps>

801067bb <vector220>:
.globl vector220
vector220:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $220
801067bd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067c2:	e9 78 f2 ff ff       	jmp    80105a3f <alltraps>

801067c7 <vector221>:
.globl vector221
vector221:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $221
801067c9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067ce:	e9 6c f2 ff ff       	jmp    80105a3f <alltraps>

801067d3 <vector222>:
.globl vector222
vector222:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $222
801067d5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067da:	e9 60 f2 ff ff       	jmp    80105a3f <alltraps>

801067df <vector223>:
.globl vector223
vector223:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $223
801067e1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067e6:	e9 54 f2 ff ff       	jmp    80105a3f <alltraps>

801067eb <vector224>:
.globl vector224
vector224:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $224
801067ed:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067f2:	e9 48 f2 ff ff       	jmp    80105a3f <alltraps>

801067f7 <vector225>:
.globl vector225
vector225:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $225
801067f9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067fe:	e9 3c f2 ff ff       	jmp    80105a3f <alltraps>

80106803 <vector226>:
.globl vector226
vector226:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $226
80106805:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010680a:	e9 30 f2 ff ff       	jmp    80105a3f <alltraps>

8010680f <vector227>:
.globl vector227
vector227:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $227
80106811:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106816:	e9 24 f2 ff ff       	jmp    80105a3f <alltraps>

8010681b <vector228>:
.globl vector228
vector228:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $228
8010681d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106822:	e9 18 f2 ff ff       	jmp    80105a3f <alltraps>

80106827 <vector229>:
.globl vector229
vector229:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $229
80106829:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010682e:	e9 0c f2 ff ff       	jmp    80105a3f <alltraps>

80106833 <vector230>:
.globl vector230
vector230:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $230
80106835:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010683a:	e9 00 f2 ff ff       	jmp    80105a3f <alltraps>

8010683f <vector231>:
.globl vector231
vector231:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $231
80106841:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106846:	e9 f4 f1 ff ff       	jmp    80105a3f <alltraps>

8010684b <vector232>:
.globl vector232
vector232:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $232
8010684d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106852:	e9 e8 f1 ff ff       	jmp    80105a3f <alltraps>

80106857 <vector233>:
.globl vector233
vector233:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $233
80106859:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010685e:	e9 dc f1 ff ff       	jmp    80105a3f <alltraps>

80106863 <vector234>:
.globl vector234
vector234:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $234
80106865:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010686a:	e9 d0 f1 ff ff       	jmp    80105a3f <alltraps>

8010686f <vector235>:
.globl vector235
vector235:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $235
80106871:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106876:	e9 c4 f1 ff ff       	jmp    80105a3f <alltraps>

8010687b <vector236>:
.globl vector236
vector236:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $236
8010687d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106882:	e9 b8 f1 ff ff       	jmp    80105a3f <alltraps>

80106887 <vector237>:
.globl vector237
vector237:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $237
80106889:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010688e:	e9 ac f1 ff ff       	jmp    80105a3f <alltraps>

80106893 <vector238>:
.globl vector238
vector238:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $238
80106895:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010689a:	e9 a0 f1 ff ff       	jmp    80105a3f <alltraps>

8010689f <vector239>:
.globl vector239
vector239:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $239
801068a1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068a6:	e9 94 f1 ff ff       	jmp    80105a3f <alltraps>

801068ab <vector240>:
.globl vector240
vector240:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $240
801068ad:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068b2:	e9 88 f1 ff ff       	jmp    80105a3f <alltraps>

801068b7 <vector241>:
.globl vector241
vector241:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $241
801068b9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068be:	e9 7c f1 ff ff       	jmp    80105a3f <alltraps>

801068c3 <vector242>:
.globl vector242
vector242:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $242
801068c5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068ca:	e9 70 f1 ff ff       	jmp    80105a3f <alltraps>

801068cf <vector243>:
.globl vector243
vector243:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $243
801068d1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068d6:	e9 64 f1 ff ff       	jmp    80105a3f <alltraps>

801068db <vector244>:
.globl vector244
vector244:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $244
801068dd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068e2:	e9 58 f1 ff ff       	jmp    80105a3f <alltraps>

801068e7 <vector245>:
.globl vector245
vector245:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $245
801068e9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068ee:	e9 4c f1 ff ff       	jmp    80105a3f <alltraps>

801068f3 <vector246>:
.globl vector246
vector246:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $246
801068f5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068fa:	e9 40 f1 ff ff       	jmp    80105a3f <alltraps>

801068ff <vector247>:
.globl vector247
vector247:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $247
80106901:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106906:	e9 34 f1 ff ff       	jmp    80105a3f <alltraps>

8010690b <vector248>:
.globl vector248
vector248:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $248
8010690d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106912:	e9 28 f1 ff ff       	jmp    80105a3f <alltraps>

80106917 <vector249>:
.globl vector249
vector249:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $249
80106919:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010691e:	e9 1c f1 ff ff       	jmp    80105a3f <alltraps>

80106923 <vector250>:
.globl vector250
vector250:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $250
80106925:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010692a:	e9 10 f1 ff ff       	jmp    80105a3f <alltraps>

8010692f <vector251>:
.globl vector251
vector251:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $251
80106931:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106936:	e9 04 f1 ff ff       	jmp    80105a3f <alltraps>

8010693b <vector252>:
.globl vector252
vector252:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $252
8010693d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106942:	e9 f8 f0 ff ff       	jmp    80105a3f <alltraps>

80106947 <vector253>:
.globl vector253
vector253:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $253
80106949:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010694e:	e9 ec f0 ff ff       	jmp    80105a3f <alltraps>

80106953 <vector254>:
.globl vector254
vector254:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $254
80106955:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010695a:	e9 e0 f0 ff ff       	jmp    80105a3f <alltraps>

8010695f <vector255>:
.globl vector255
vector255:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $255
80106961:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106966:	e9 d4 f0 ff ff       	jmp    80105a3f <alltraps>
8010696b:	66 90                	xchg   %ax,%ax
8010696d:	66 90                	xchg   %ax,%ax
8010696f:	90                   	nop

80106970 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106977:	c1 ea 16             	shr    $0x16,%edx
{
8010697a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010697b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010697e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106981:	8b 1f                	mov    (%edi),%ebx
80106983:	f6 c3 01             	test   $0x1,%bl
80106986:	74 28                	je     801069b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106988:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010698e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106994:	89 f0                	mov    %esi,%eax
}
80106996:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106999:	c1 e8 0a             	shr    $0xa,%eax
8010699c:	25 fc 0f 00 00       	and    $0xffc,%eax
801069a1:	01 d8                	add    %ebx,%eax
}
801069a3:	5b                   	pop    %ebx
801069a4:	5e                   	pop    %esi
801069a5:	5f                   	pop    %edi
801069a6:	5d                   	pop    %ebp
801069a7:	c3                   	ret    
801069a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069af:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069b0:	85 c9                	test   %ecx,%ecx
801069b2:	74 2c                	je     801069e0 <walkpgdir+0x70>
801069b4:	e8 77 bc ff ff       	call   80102630 <kalloc>
801069b9:	89 c3                	mov    %eax,%ebx
801069bb:	85 c0                	test   %eax,%eax
801069bd:	74 21                	je     801069e0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801069bf:	83 ec 04             	sub    $0x4,%esp
801069c2:	68 00 10 00 00       	push   $0x1000
801069c7:	6a 00                	push   $0x0
801069c9:	50                   	push   %eax
801069ca:	e8 f1 dd ff ff       	call   801047c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069cf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	83 c8 07             	or     $0x7,%eax
801069db:	89 07                	mov    %eax,(%edi)
801069dd:	eb b5                	jmp    80106994 <walkpgdir+0x24>
801069df:	90                   	nop
}
801069e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801069e3:	31 c0                	xor    %eax,%eax
}
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069f6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801069fa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a00:	89 d6                	mov    %edx,%esi
{
80106a02:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a03:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106a09:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a12:	29 f0                	sub    %esi,%eax
80106a14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a17:	eb 1f                	jmp    80106a38 <mappages+0x48>
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106a20:	f6 00 01             	testb  $0x1,(%eax)
80106a23:	75 45                	jne    80106a6a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a25:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106a28:	83 cb 01             	or     $0x1,%ebx
80106a2b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106a2d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106a30:	74 2e                	je     80106a60 <mappages+0x70>
      break;
    a += PGSIZE;
80106a32:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a3b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a40:	89 f2                	mov    %esi,%edx
80106a42:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106a45:	89 f8                	mov    %edi,%eax
80106a47:	e8 24 ff ff ff       	call   80106970 <walkpgdir>
80106a4c:	85 c0                	test   %eax,%eax
80106a4e:	75 d0                	jne    80106a20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a58:	5b                   	pop    %ebx
80106a59:	5e                   	pop    %esi
80106a5a:	5f                   	pop    %edi
80106a5b:	5d                   	pop    %ebp
80106a5c:	c3                   	ret    
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi
80106a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a63:	31 c0                	xor    %eax,%eax
}
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5f                   	pop    %edi
80106a68:	5d                   	pop    %ebp
80106a69:	c3                   	ret    
      panic("remap");
80106a6a:	83 ec 0c             	sub    $0xc,%esp
80106a6d:	68 70 7b 10 80       	push   $0x80107b70
80106a72:	e8 19 99 ff ff       	call   80100390 <panic>
80106a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7e:	66 90                	xchg   %ax,%ax

80106a80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	89 c6                	mov    %eax,%esi
80106a87:	53                   	push   %ebx
80106a88:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a8a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106a90:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a9c:	39 da                	cmp    %ebx,%edx
80106a9e:	73 5b                	jae    80106afb <deallocuvm.part.0+0x7b>
80106aa0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106aa3:	89 d7                	mov    %edx,%edi
80106aa5:	eb 14                	jmp    80106abb <deallocuvm.part.0+0x3b>
80106aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aae:	66 90                	xchg   %ax,%ax
80106ab0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ab6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106ab9:	76 40                	jbe    80106afb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106abb:	31 c9                	xor    %ecx,%ecx
80106abd:	89 fa                	mov    %edi,%edx
80106abf:	89 f0                	mov    %esi,%eax
80106ac1:	e8 aa fe ff ff       	call   80106970 <walkpgdir>
80106ac6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106ac8:	85 c0                	test   %eax,%eax
80106aca:	74 44                	je     80106b10 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106acc:	8b 00                	mov    (%eax),%eax
80106ace:	a8 01                	test   $0x1,%al
80106ad0:	74 de                	je     80106ab0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ad2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ad7:	74 47                	je     80106b20 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ad9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106adc:	05 00 00 00 80       	add    $0x80000000,%eax
80106ae1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106ae7:	50                   	push   %eax
80106ae8:	e8 83 b9 ff ff       	call   80102470 <kfree>
      *pte = 0;
80106aed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106af3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106af6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106af9:	77 c0                	ja     80106abb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b01:	5b                   	pop    %ebx
80106b02:	5e                   	pop    %esi
80106b03:	5f                   	pop    %edi
80106b04:	5d                   	pop    %ebp
80106b05:	c3                   	ret    
80106b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b0d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b10:	89 fa                	mov    %edi,%edx
80106b12:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106b18:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106b1e:	eb 96                	jmp    80106ab6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106b20:	83 ec 0c             	sub    $0xc,%esp
80106b23:	68 26 75 10 80       	push   $0x80107526
80106b28:	e8 63 98 ff ff       	call   80100390 <panic>
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <seginit>:
{
80106b30:	f3 0f 1e fb          	endbr32 
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b3a:	e8 21 ce ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106b3f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b44:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b4a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b4e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106b55:	ff 00 00 
80106b58:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106b5f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b62:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106b69:	ff 00 00 
80106b6c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106b73:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b76:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106b7d:	ff 00 00 
80106b80:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106b87:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b8a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106b91:	ff 00 00 
80106b94:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106b9b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b9e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106ba3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ba7:	c1 e8 10             	shr    $0x10,%eax
80106baa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bae:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bb1:	0f 01 10             	lgdtl  (%eax)
}
80106bb4:	c9                   	leave  
80106bb5:	c3                   	ret    
80106bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbd:	8d 76 00             	lea    0x0(%esi),%esi

80106bc0 <switchkvm>:
{
80106bc0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bc4:	a1 a4 56 12 80       	mov    0x801256a4,%eax
80106bc9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bce:	0f 22 d8             	mov    %eax,%cr3
}
80106bd1:	c3                   	ret    
80106bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106be0 <switchuvm>:
{
80106be0:	f3 0f 1e fb          	endbr32 
80106be4:	55                   	push   %ebp
80106be5:	89 e5                	mov    %esp,%ebp
80106be7:	57                   	push   %edi
80106be8:	56                   	push   %esi
80106be9:	53                   	push   %ebx
80106bea:	83 ec 1c             	sub    $0x1c,%esp
80106bed:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106bf0:	85 f6                	test   %esi,%esi
80106bf2:	0f 84 cb 00 00 00    	je     80106cc3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106bf8:	8b 46 08             	mov    0x8(%esi),%eax
80106bfb:	85 c0                	test   %eax,%eax
80106bfd:	0f 84 da 00 00 00    	je     80106cdd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106c03:	8b 46 04             	mov    0x4(%esi),%eax
80106c06:	85 c0                	test   %eax,%eax
80106c08:	0f 84 c2 00 00 00    	je     80106cd0 <switchuvm+0xf0>
  pushcli();
80106c0e:	e8 9d d9 ff ff       	call   801045b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c13:	e8 d8 cc ff ff       	call   801038f0 <mycpu>
80106c18:	89 c3                	mov    %eax,%ebx
80106c1a:	e8 d1 cc ff ff       	call   801038f0 <mycpu>
80106c1f:	89 c7                	mov    %eax,%edi
80106c21:	e8 ca cc ff ff       	call   801038f0 <mycpu>
80106c26:	83 c7 08             	add    $0x8,%edi
80106c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c2c:	e8 bf cc ff ff       	call   801038f0 <mycpu>
80106c31:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c34:	ba 67 00 00 00       	mov    $0x67,%edx
80106c39:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c40:	83 c0 08             	add    $0x8,%eax
80106c43:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c4a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c4f:	83 c1 08             	add    $0x8,%ecx
80106c52:	c1 e8 18             	shr    $0x18,%eax
80106c55:	c1 e9 10             	shr    $0x10,%ecx
80106c58:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c5e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c64:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c69:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c70:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c75:	e8 76 cc ff ff       	call   801038f0 <mycpu>
80106c7a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c81:	e8 6a cc ff ff       	call   801038f0 <mycpu>
80106c86:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c8a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c8d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c93:	e8 58 cc ff ff       	call   801038f0 <mycpu>
80106c98:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c9b:	e8 50 cc ff ff       	call   801038f0 <mycpu>
80106ca0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ca4:	b8 28 00 00 00       	mov    $0x28,%eax
80106ca9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cac:	8b 46 04             	mov    0x4(%esi),%eax
80106caf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cb4:	0f 22 d8             	mov    %eax,%cr3
}
80106cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cba:	5b                   	pop    %ebx
80106cbb:	5e                   	pop    %esi
80106cbc:	5f                   	pop    %edi
80106cbd:	5d                   	pop    %ebp
  popcli();
80106cbe:	e9 3d d9 ff ff       	jmp    80104600 <popcli>
    panic("switchuvm: no process");
80106cc3:	83 ec 0c             	sub    $0xc,%esp
80106cc6:	68 76 7b 10 80       	push   $0x80107b76
80106ccb:	e8 c0 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106cd0:	83 ec 0c             	sub    $0xc,%esp
80106cd3:	68 a1 7b 10 80       	push   $0x80107ba1
80106cd8:	e8 b3 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106cdd:	83 ec 0c             	sub    $0xc,%esp
80106ce0:	68 8c 7b 10 80       	push   $0x80107b8c
80106ce5:	e8 a6 96 ff ff       	call   80100390 <panic>
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <inituvm>:
{
80106cf0:	f3 0f 1e fb          	endbr32 
80106cf4:	55                   	push   %ebp
80106cf5:	89 e5                	mov    %esp,%ebp
80106cf7:	57                   	push   %edi
80106cf8:	56                   	push   %esi
80106cf9:	53                   	push   %ebx
80106cfa:	83 ec 1c             	sub    $0x1c,%esp
80106cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d00:	8b 75 10             	mov    0x10(%ebp),%esi
80106d03:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d09:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d0f:	77 4b                	ja     80106d5c <inituvm+0x6c>
  mem = kalloc();
80106d11:	e8 1a b9 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80106d16:	83 ec 04             	sub    $0x4,%esp
80106d19:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d1e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d20:	6a 00                	push   $0x0
80106d22:	50                   	push   %eax
80106d23:	e8 98 da ff ff       	call   801047c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d28:	58                   	pop    %eax
80106d29:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d2f:	5a                   	pop    %edx
80106d30:	6a 06                	push   $0x6
80106d32:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d37:	31 d2                	xor    %edx,%edx
80106d39:	50                   	push   %eax
80106d3a:	89 f8                	mov    %edi,%eax
80106d3c:	e8 af fc ff ff       	call   801069f0 <mappages>
  memmove(mem, init, sz);
80106d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d44:	89 75 10             	mov    %esi,0x10(%ebp)
80106d47:	83 c4 10             	add    $0x10,%esp
80106d4a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d4d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d53:	5b                   	pop    %ebx
80106d54:	5e                   	pop    %esi
80106d55:	5f                   	pop    %edi
80106d56:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d57:	e9 04 db ff ff       	jmp    80104860 <memmove>
    panic("inituvm: more than a page");
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	68 b5 7b 10 80       	push   $0x80107bb5
80106d64:	e8 27 96 ff ff       	call   80100390 <panic>
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <loaduvm>:
{
80106d70:	f3 0f 1e fb          	endbr32 
80106d74:	55                   	push   %ebp
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	57                   	push   %edi
80106d78:	56                   	push   %esi
80106d79:	53                   	push   %ebx
80106d7a:	83 ec 1c             	sub    $0x1c,%esp
80106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d80:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106d83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106d88:	0f 85 99 00 00 00    	jne    80106e27 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106d8e:	01 f0                	add    %esi,%eax
80106d90:	89 f3                	mov    %esi,%ebx
80106d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d95:	8b 45 14             	mov    0x14(%ebp),%eax
80106d98:	01 f0                	add    %esi,%eax
80106d9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106d9d:	85 f6                	test   %esi,%esi
80106d9f:	75 15                	jne    80106db6 <loaduvm+0x46>
80106da1:	eb 6d                	jmp    80106e10 <loaduvm+0xa0>
80106da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106da7:	90                   	nop
80106da8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106dae:	89 f0                	mov    %esi,%eax
80106db0:	29 d8                	sub    %ebx,%eax
80106db2:	39 c6                	cmp    %eax,%esi
80106db4:	76 5a                	jbe    80106e10 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106db6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106db9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbc:	31 c9                	xor    %ecx,%ecx
80106dbe:	29 da                	sub    %ebx,%edx
80106dc0:	e8 ab fb ff ff       	call   80106970 <walkpgdir>
80106dc5:	85 c0                	test   %eax,%eax
80106dc7:	74 51                	je     80106e1a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106dc9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dcb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106dce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106dd8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106dde:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106de1:	29 d9                	sub    %ebx,%ecx
80106de3:	05 00 00 00 80       	add    $0x80000000,%eax
80106de8:	57                   	push   %edi
80106de9:	51                   	push   %ecx
80106dea:	50                   	push   %eax
80106deb:	ff 75 10             	pushl  0x10(%ebp)
80106dee:	e8 6d ac ff ff       	call   80101a60 <readi>
80106df3:	83 c4 10             	add    $0x10,%esp
80106df6:	39 f8                	cmp    %edi,%eax
80106df8:	74 ae                	je     80106da8 <loaduvm+0x38>
}
80106dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e02:	5b                   	pop    %ebx
80106e03:	5e                   	pop    %esi
80106e04:	5f                   	pop    %edi
80106e05:	5d                   	pop    %ebp
80106e06:	c3                   	ret    
80106e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0e:	66 90                	xchg   %ax,%ax
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 cf 7b 10 80       	push   $0x80107bcf
80106e22:	e8 69 95 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106e27:	83 ec 0c             	sub    $0xc,%esp
80106e2a:	68 70 7c 10 80       	push   $0x80107c70
80106e2f:	e8 5c 95 ff ff       	call   80100390 <panic>
80106e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop

80106e40 <allocuvm>:
{
80106e40:	f3 0f 1e fb          	endbr32 
80106e44:	55                   	push   %ebp
80106e45:	89 e5                	mov    %esp,%ebp
80106e47:	57                   	push   %edi
80106e48:	56                   	push   %esi
80106e49:	53                   	push   %ebx
80106e4a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e4d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106e50:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e56:	85 c0                	test   %eax,%eax
80106e58:	0f 88 b2 00 00 00    	js     80106f10 <allocuvm+0xd0>
  if(newsz < oldsz)
80106e5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e64:	0f 82 96 00 00 00    	jb     80106f00 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e6a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106e70:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106e76:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e79:	77 40                	ja     80106ebb <allocuvm+0x7b>
80106e7b:	e9 83 00 00 00       	jmp    80106f03 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106e80:	83 ec 04             	sub    $0x4,%esp
80106e83:	68 00 10 00 00       	push   $0x1000
80106e88:	6a 00                	push   $0x0
80106e8a:	50                   	push   %eax
80106e8b:	e8 30 d9 ff ff       	call   801047c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e90:	58                   	pop    %eax
80106e91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e97:	5a                   	pop    %edx
80106e98:	6a 06                	push   $0x6
80106e9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e9f:	89 f2                	mov    %esi,%edx
80106ea1:	50                   	push   %eax
80106ea2:	89 f8                	mov    %edi,%eax
80106ea4:	e8 47 fb ff ff       	call   801069f0 <mappages>
80106ea9:	83 c4 10             	add    $0x10,%esp
80106eac:	85 c0                	test   %eax,%eax
80106eae:	78 78                	js     80106f28 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106eb0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106eb9:	76 48                	jbe    80106f03 <allocuvm+0xc3>
    mem = kalloc();
80106ebb:	e8 70 b7 ff ff       	call   80102630 <kalloc>
80106ec0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ec2:	85 c0                	test   %eax,%eax
80106ec4:	75 ba                	jne    80106e80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	68 ed 7b 10 80       	push   $0x80107bed
80106ece:	e8 dd 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ed6:	83 c4 10             	add    $0x10,%esp
80106ed9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106edc:	74 32                	je     80106f10 <allocuvm+0xd0>
80106ede:	8b 55 10             	mov    0x10(%ebp),%edx
80106ee1:	89 c1                	mov    %eax,%ecx
80106ee3:	89 f8                	mov    %edi,%eax
80106ee5:	e8 96 fb ff ff       	call   80106a80 <deallocuvm.part.0>
      return 0;
80106eea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef7:	5b                   	pop    %ebx
80106ef8:	5e                   	pop    %esi
80106ef9:	5f                   	pop    %edi
80106efa:	5d                   	pop    %ebp
80106efb:	c3                   	ret    
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f09:	5b                   	pop    %ebx
80106f0a:	5e                   	pop    %esi
80106f0b:	5f                   	pop    %edi
80106f0c:	5d                   	pop    %ebp
80106f0d:	c3                   	ret    
80106f0e:	66 90                	xchg   %ax,%ax
    return 0;
80106f10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5f                   	pop    %edi
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
80106f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f28:	83 ec 0c             	sub    $0xc,%esp
80106f2b:	68 05 7c 10 80       	push   $0x80107c05
80106f30:	e8 7b 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f35:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f38:	83 c4 10             	add    $0x10,%esp
80106f3b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f3e:	74 0c                	je     80106f4c <allocuvm+0x10c>
80106f40:	8b 55 10             	mov    0x10(%ebp),%edx
80106f43:	89 c1                	mov    %eax,%ecx
80106f45:	89 f8                	mov    %edi,%eax
80106f47:	e8 34 fb ff ff       	call   80106a80 <deallocuvm.part.0>
      kfree(mem);
80106f4c:	83 ec 0c             	sub    $0xc,%esp
80106f4f:	53                   	push   %ebx
80106f50:	e8 1b b5 ff ff       	call   80102470 <kfree>
      return 0;
80106f55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f5c:	83 c4 10             	add    $0x10,%esp
}
80106f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f70 <deallocuvm>:
{
80106f70:	f3 0f 1e fb          	endbr32 
80106f74:	55                   	push   %ebp
80106f75:	89 e5                	mov    %esp,%ebp
80106f77:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f80:	39 d1                	cmp    %edx,%ecx
80106f82:	73 0c                	jae    80106f90 <deallocuvm+0x20>
}
80106f84:	5d                   	pop    %ebp
80106f85:	e9 f6 fa ff ff       	jmp    80106a80 <deallocuvm.part.0>
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f90:	89 d0                	mov    %edx,%eax
80106f92:	5d                   	pop    %ebp
80106f93:	c3                   	ret    
80106f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f9f:	90                   	nop

80106fa0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fa0:	f3 0f 1e fb          	endbr32 
80106fa4:	55                   	push   %ebp
80106fa5:	89 e5                	mov    %esp,%ebp
80106fa7:	57                   	push   %edi
80106fa8:	56                   	push   %esi
80106fa9:	53                   	push   %ebx
80106faa:	83 ec 0c             	sub    $0xc,%esp
80106fad:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106fb0:	85 f6                	test   %esi,%esi
80106fb2:	74 55                	je     80107009 <freevm+0x69>
  if(newsz >= oldsz)
80106fb4:	31 c9                	xor    %ecx,%ecx
80106fb6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fbb:	89 f0                	mov    %esi,%eax
80106fbd:	89 f3                	mov    %esi,%ebx
80106fbf:	e8 bc fa ff ff       	call   80106a80 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fc4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fca:	eb 0b                	jmp    80106fd7 <freevm+0x37>
80106fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fd0:	83 c3 04             	add    $0x4,%ebx
80106fd3:	39 df                	cmp    %ebx,%edi
80106fd5:	74 23                	je     80106ffa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fd7:	8b 03                	mov    (%ebx),%eax
80106fd9:	a8 01                	test   $0x1,%al
80106fdb:	74 f3                	je     80106fd0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106fe2:	83 ec 0c             	sub    $0xc,%esp
80106fe5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fe8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fed:	50                   	push   %eax
80106fee:	e8 7d b4 ff ff       	call   80102470 <kfree>
80106ff3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ff6:	39 df                	cmp    %ebx,%edi
80106ff8:	75 dd                	jne    80106fd7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106ffa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107000:	5b                   	pop    %ebx
80107001:	5e                   	pop    %esi
80107002:	5f                   	pop    %edi
80107003:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107004:	e9 67 b4 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107009:	83 ec 0c             	sub    $0xc,%esp
8010700c:	68 21 7c 10 80       	push   $0x80107c21
80107011:	e8 7a 93 ff ff       	call   80100390 <panic>
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi

80107020 <setupkvm>:
{
80107020:	f3 0f 1e fb          	endbr32 
80107024:	55                   	push   %ebp
80107025:	89 e5                	mov    %esp,%ebp
80107027:	56                   	push   %esi
80107028:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107029:	e8 02 b6 ff ff       	call   80102630 <kalloc>
8010702e:	89 c6                	mov    %eax,%esi
80107030:	85 c0                	test   %eax,%eax
80107032:	74 42                	je     80107076 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107034:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107037:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010703c:	68 00 10 00 00       	push   $0x1000
80107041:	6a 00                	push   $0x0
80107043:	50                   	push   %eax
80107044:	e8 77 d7 ff ff       	call   801047c0 <memset>
80107049:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010704c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010704f:	83 ec 08             	sub    $0x8,%esp
80107052:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107055:	ff 73 0c             	pushl  0xc(%ebx)
80107058:	8b 13                	mov    (%ebx),%edx
8010705a:	50                   	push   %eax
8010705b:	29 c1                	sub    %eax,%ecx
8010705d:	89 f0                	mov    %esi,%eax
8010705f:	e8 8c f9 ff ff       	call   801069f0 <mappages>
80107064:	83 c4 10             	add    $0x10,%esp
80107067:	85 c0                	test   %eax,%eax
80107069:	78 15                	js     80107080 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010706b:	83 c3 10             	add    $0x10,%ebx
8010706e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107074:	75 d6                	jne    8010704c <setupkvm+0x2c>
}
80107076:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107079:	89 f0                	mov    %esi,%eax
8010707b:	5b                   	pop    %ebx
8010707c:	5e                   	pop    %esi
8010707d:	5d                   	pop    %ebp
8010707e:	c3                   	ret    
8010707f:	90                   	nop
      freevm(pgdir);
80107080:	83 ec 0c             	sub    $0xc,%esp
80107083:	56                   	push   %esi
      return 0;
80107084:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107086:	e8 15 ff ff ff       	call   80106fa0 <freevm>
      return 0;
8010708b:	83 c4 10             	add    $0x10,%esp
}
8010708e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107091:	89 f0                	mov    %esi,%eax
80107093:	5b                   	pop    %ebx
80107094:	5e                   	pop    %esi
80107095:	5d                   	pop    %ebp
80107096:	c3                   	ret    
80107097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709e:	66 90                	xchg   %ax,%ax

801070a0 <kvmalloc>:
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070aa:	e8 71 ff ff ff       	call   80107020 <setupkvm>
801070af:	a3 a4 56 12 80       	mov    %eax,0x801256a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070b4:	05 00 00 00 80       	add    $0x80000000,%eax
801070b9:	0f 22 d8             	mov    %eax,%cr3
}
801070bc:	c9                   	leave  
801070bd:	c3                   	ret    
801070be:	66 90                	xchg   %ax,%ax

801070c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070c5:	31 c9                	xor    %ecx,%ecx
{
801070c7:	89 e5                	mov    %esp,%ebp
801070c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801070cf:	8b 45 08             	mov    0x8(%ebp),%eax
801070d2:	e8 99 f8 ff ff       	call   80106970 <walkpgdir>
  if(pte == 0)
801070d7:	85 c0                	test   %eax,%eax
801070d9:	74 05                	je     801070e0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070db:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070de:	c9                   	leave  
801070df:	c3                   	ret    
    panic("clearpteu");
801070e0:	83 ec 0c             	sub    $0xc,%esp
801070e3:	68 32 7c 10 80       	push   $0x80107c32
801070e8:	e8 a3 92 ff ff       	call   80100390 <panic>
801070ed:	8d 76 00             	lea    0x0(%esi),%esi

801070f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070f0:	f3 0f 1e fb          	endbr32 
801070f4:	55                   	push   %ebp
801070f5:	89 e5                	mov    %esp,%ebp
801070f7:	57                   	push   %edi
801070f8:	56                   	push   %esi
801070f9:	53                   	push   %ebx
801070fa:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070fd:	e8 1e ff ff ff       	call   80107020 <setupkvm>
80107102:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107105:	85 c0                	test   %eax,%eax
80107107:	0f 84 9b 00 00 00    	je     801071a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010710d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107110:	85 c9                	test   %ecx,%ecx
80107112:	0f 84 90 00 00 00    	je     801071a8 <copyuvm+0xb8>
80107118:	31 f6                	xor    %esi,%esi
8010711a:	eb 46                	jmp    80107162 <copyuvm+0x72>
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
80107123:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107129:	68 00 10 00 00       	push   $0x1000
8010712e:	57                   	push   %edi
8010712f:	50                   	push   %eax
80107130:	e8 2b d7 ff ff       	call   80104860 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107135:	58                   	pop    %eax
80107136:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010713c:	5a                   	pop    %edx
8010713d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107140:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107145:	89 f2                	mov    %esi,%edx
80107147:	50                   	push   %eax
80107148:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010714b:	e8 a0 f8 ff ff       	call   801069f0 <mappages>
80107150:	83 c4 10             	add    $0x10,%esp
80107153:	85 c0                	test   %eax,%eax
80107155:	78 61                	js     801071b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107157:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010715d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107160:	76 46                	jbe    801071a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107162:	8b 45 08             	mov    0x8(%ebp),%eax
80107165:	31 c9                	xor    %ecx,%ecx
80107167:	89 f2                	mov    %esi,%edx
80107169:	e8 02 f8 ff ff       	call   80106970 <walkpgdir>
8010716e:	85 c0                	test   %eax,%eax
80107170:	74 61                	je     801071d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107172:	8b 00                	mov    (%eax),%eax
80107174:	a8 01                	test   $0x1,%al
80107176:	74 4e                	je     801071c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107178:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010717a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010717f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107182:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107188:	e8 a3 b4 ff ff       	call   80102630 <kalloc>
8010718d:	89 c3                	mov    %eax,%ebx
8010718f:	85 c0                	test   %eax,%eax
80107191:	75 8d                	jne    80107120 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107193:	83 ec 0c             	sub    $0xc,%esp
80107196:	ff 75 e0             	pushl  -0x20(%ebp)
80107199:	e8 02 fe ff ff       	call   80106fa0 <freevm>
  return 0;
8010719e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801071a5:	83 c4 10             	add    $0x10,%esp
}
801071a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ae:	5b                   	pop    %ebx
801071af:	5e                   	pop    %esi
801071b0:	5f                   	pop    %edi
801071b1:	5d                   	pop    %ebp
801071b2:	c3                   	ret    
801071b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071b7:	90                   	nop
      kfree(mem);
801071b8:	83 ec 0c             	sub    $0xc,%esp
801071bb:	53                   	push   %ebx
801071bc:	e8 af b2 ff ff       	call   80102470 <kfree>
      goto bad;
801071c1:	83 c4 10             	add    $0x10,%esp
801071c4:	eb cd                	jmp    80107193 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	68 56 7c 10 80       	push   $0x80107c56
801071ce:	e8 bd 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801071d3:	83 ec 0c             	sub    $0xc,%esp
801071d6:	68 3c 7c 10 80       	push   $0x80107c3c
801071db:	e8 b0 91 ff ff       	call   80100390 <panic>

801071e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071e5:	31 c9                	xor    %ecx,%ecx
{
801071e7:	89 e5                	mov    %esp,%ebp
801071e9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ef:	8b 45 08             	mov    0x8(%ebp),%eax
801071f2:	e8 79 f7 ff ff       	call   80106970 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071f7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071f9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801071fa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107201:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107204:	05 00 00 00 80       	add    $0x80000000,%eax
80107209:	83 fa 05             	cmp    $0x5,%edx
8010720c:	ba 00 00 00 00       	mov    $0x0,%edx
80107211:	0f 45 c2             	cmovne %edx,%eax
}
80107214:	c3                   	ret    
80107215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107220 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	57                   	push   %edi
80107228:	56                   	push   %esi
80107229:	53                   	push   %ebx
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	8b 75 14             	mov    0x14(%ebp),%esi
80107230:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107233:	85 f6                	test   %esi,%esi
80107235:	75 3c                	jne    80107273 <copyout+0x53>
80107237:	eb 67                	jmp    801072a0 <copyout+0x80>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107240:	8b 55 0c             	mov    0xc(%ebp),%edx
80107243:	89 fb                	mov    %edi,%ebx
80107245:	29 d3                	sub    %edx,%ebx
80107247:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010724d:	39 f3                	cmp    %esi,%ebx
8010724f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107252:	29 fa                	sub    %edi,%edx
80107254:	83 ec 04             	sub    $0x4,%esp
80107257:	01 c2                	add    %eax,%edx
80107259:	53                   	push   %ebx
8010725a:	ff 75 10             	pushl  0x10(%ebp)
8010725d:	52                   	push   %edx
8010725e:	e8 fd d5 ff ff       	call   80104860 <memmove>
    len -= n;
    buf += n;
80107263:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107266:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010726c:	83 c4 10             	add    $0x10,%esp
8010726f:	29 de                	sub    %ebx,%esi
80107271:	74 2d                	je     801072a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107273:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107275:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107278:	89 55 0c             	mov    %edx,0xc(%ebp)
8010727b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107281:	57                   	push   %edi
80107282:	ff 75 08             	pushl  0x8(%ebp)
80107285:	e8 56 ff ff ff       	call   801071e0 <uva2ka>
    if(pa0 == 0)
8010728a:	83 c4 10             	add    $0x10,%esp
8010728d:	85 c0                	test   %eax,%eax
8010728f:	75 af                	jne    80107240 <copyout+0x20>
  }
  return 0;
}
80107291:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107299:	5b                   	pop    %ebx
8010729a:	5e                   	pop    %esi
8010729b:	5f                   	pop    %edi
8010729c:	5d                   	pop    %ebp
8010729d:	c3                   	ret    
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
