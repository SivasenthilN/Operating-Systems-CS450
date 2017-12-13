
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2f 10 80       	mov    $0x80102f70,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 80 72 10 	movl   $0x80107280,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 f0 41 00 00       	call   80104250 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 87 72 10 	movl   $0x80107287,0x4(%esp)
8010009b:	80 
8010009c:	e8 9f 40 00 00       	call   80104140 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 e5 41 00 00       	call   801042d0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 9a 42 00 00       	call   80104400 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 40 00 00       	call   80104180 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 20 00 00       	call   80102230 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 8e 72 10 80 	movl   $0x8010728e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 6b 40 00 00       	call   80104220 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 67 20 00 00       	jmp    80102230 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 9f 72 10 80 	movl   $0x8010729f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 2a 40 00 00       	call   80104220 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 3f 00 00       	call   801041e0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 c2 40 00 00       	call   801042d0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 ab 41 00 00       	jmp    80104400 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 a6 72 10 80 	movl   $0x801072a6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 3d 40 00 00       	call   801042d0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c4:	e8 27 3b 00 00       	call   80103df0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ce:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 e9 40 00 00       	call   80104400 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 91 13 00 00       	call   801016b0 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 cc 40 00 00       	call   80104400 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 ad 72 10 80 	movl   $0x801072ad,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 e6 77 10 80 	movl   $0x801077e6,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 b8 3e 00 00       	call   80104270 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 a2 59 00 00       	call   80105db0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 f2 58 00 00       	call   80105db0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 e6 58 00 00       	call   80105db0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 da 58 00 00       	call   80105db0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ef 3f 00 00       	call   801044f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 32 3f 00 00       	call   80104450 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 cd 72 10 80 	movl   $0x801072cd,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 f8 72 10 80 	movzbl -0x7fef8d08(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 bd 3c 00 00       	call   801042d0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 c5 3d 00 00       	call   80104400 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 08 3d 00 00       	call   80104400 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 e0 72 10 80       	mov    $0x801072e0,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 34 3b 00 00       	call   801042d0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 e7 72 10 80 	movl   $0x801072e7,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 06 3b 00 00       	call   801042d0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 d4 3b 00 00       	call   80104400 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 d9 36 00 00       	call   80103f90 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 44 37 00 00       	jmp    80104070 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 f0 72 10 	movl   $0x801072f0,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 e6 38 00 00       	call   80104250 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 7c 29 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 18 1a 00 00       	call   801023c0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009bc:	e8 df 22 00 00       	call   80102ca0 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 34 16 00 00       	call   80102000 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 d6 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 74 0f 00 00       	call   80101970 <readi>
801009fc:	83 f8 34             	cmp    $0x34,%eax
801009ff:	74 1f                	je     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 17 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a09:	e8 02 23 00 00       	call   80102d10 <end_op>
  }
  return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 ff 61 00 00       	call   80106c30 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x183>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 29 64 00 00       	call   80106f00 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 28 63 00 00       	call   80106e40 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 e2 64 00 00       	call   80107010 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 cb 21 00 00       	call   80102d10 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 8f 63 00 00       	call   80106f00 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b79:	75 18                	jne    80100b93 <exec+0x1e3>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 87 64 00 00       	call   80107010 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 80 fe ff ff       	jmp    80100a13 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b93:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b99:	89 d8                	mov    %ebx,%eax
80100b9b:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100baa:	89 04 24             	mov    %eax,(%esp)
80100bad:	e8 de 64 00 00       	call   80107090 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb5:	8b 00                	mov    (%eax),%eax
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	0f 84 66 01 00 00    	je     80100d25 <exec+0x375>
80100bbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc2:	31 f6                	xor    %esi,%esi
80100bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	89 fe                	mov    %edi,%esi
80100bcb:	89 d7                	mov    %edx,%edi
80100bcd:	83 c1 04             	add    $0x4,%ecx
80100bd0:	eb 0e                	jmp    80100be0 <exec+0x230>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bd8:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100bdb:	83 ff 20             	cmp    $0x20,%edi
80100bde:	74 9b                	je     80100b7b <exec+0x1cb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be9:	e8 82 3a 00 00       	call   80104670 <strlen>
80100bee:	f7 d0                	not    %eax
80100bf0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf2:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf7:	89 04 24             	mov    %eax,(%esp)
80100bfa:	e8 71 3a 00 00       	call   80104670 <strlen>
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 06                	mov    (%esi),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 d2 65 00 00       	call   801071f0 <copyout>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	0f 88 55 ff ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c26:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c2c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c32:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c39:	83 c7 01             	add    $0x1,%edi
80100c3c:	8b 01                	mov    (%ecx),%eax
80100c3e:	89 ce                	mov    %ecx,%esi
80100c40:	85 c0                	test   %eax,%eax
80100c42:	75 94                	jne    80100bd8 <exec+0x228>
80100c44:	89 fe                	mov    %edi,%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c46:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c4d:	89 d9                	mov    %ebx,%ecx
80100c4f:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c51:	83 c0 0c             	add    $0xc,%eax
80100c54:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c60:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c68:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c6f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c76:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c7d:	ff ff ff 
  ustack[1] = argc;
80100c80:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c86:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8c:	e8 5f 65 00 00       	call   801071f0 <copyout>
80100c91:	85 c0                	test   %eax,%eax
80100c93:	0f 88 e2 fe ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c99:	8b 45 08             	mov    0x8(%ebp),%eax
80100c9c:	0f b6 10             	movzbl (%eax),%edx
80100c9f:	84 d2                	test   %dl,%dl
80100ca1:	74 19                	je     80100cbc <exec+0x30c>
80100ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ca6:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ca9:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100caf:	0f 44 c8             	cmove  %eax,%ecx
80100cb2:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	75 f0                	jne    80100ca9 <exec+0x2f9>
80100cb9:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc6:	00 
80100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 54 39 00 00       	call   80104630 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ce8:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100ceb:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100cee:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cf4:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cfc:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d02:	8b 50 18             	mov    0x18(%eax),%edx
80100d05:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d08:	8b 50 18             	mov    0x18(%eax),%edx
80100d0b:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0e:	89 04 24             	mov    %eax,(%esp)
80100d11:	e8 da 5f 00 00       	call   80106cf0 <switchuvm>
  freevm(oldpgdir);
80100d16:	89 34 24             	mov    %esi,(%esp)
80100d19:	e8 f2 62 00 00       	call   80107010 <freevm>
  return 0;
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 ee fc ff ff       	jmp    80100a13 <exec+0x63>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d25:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d2b:	31 f6                	xor    %esi,%esi
80100d2d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d33:	e9 0e ff ff ff       	jmp    80100c46 <exec+0x296>
80100d38:	66 90                	xchg   %ax,%ax
80100d3a:	66 90                	xchg   %ax,%ax
80100d3c:	66 90                	xchg   %ax,%ax
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 09 73 10 	movl   $0x80107309,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d55:	e8 f6 34 00 00       	call   80104250 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d73:	e8 58 35 00 00       	call   801042d0 <acquire>
80100d78:	eb 11                	jmp    80100d8b <filealloc+0x2b>
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d99:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da0:	e8 5b 36 00 00       	call   80104400 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100da8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100daa:	5b                   	pop    %ebx
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100db7:	e8 44 36 00 00       	call   80104400 <release>
  return 0;
}
80100dbc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dbf:	31 c0                	xor    %eax,%eax
}
80100dc1:	5b                   	pop    %ebx
80100dc2:	5d                   	pop    %ebp
80100dc3:	c3                   	ret    
80100dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100de1:	e8 ea 34 00 00       	call   801042d0 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dfa:	e8 01 36 00 00       	call   80104400 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 10 73 10 80 	movl   $0x80107310,(%esp)
80100e0e:	e8 4d f5 ff ff       	call   80100360 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 1c             	sub    $0x1c,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e33:	e8 98 34 00 00       	call   801042d0 <acquire>
  if(f->ref < 1)
80100e38:	8b 57 04             	mov    0x4(%edi),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	0f 8e 89 00 00 00    	jle    80100ecc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e43:	83 ea 01             	sub    $0x1,%edx
80100e46:	85 d2                	test   %edx,%edx
80100e48:	89 57 04             	mov    %edx,0x4(%edi)
80100e4b:	74 13                	je     80100e60 <fileclose+0x40>
    release(&ftable.lock);
80100e4d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e54:	83 c4 1c             	add    $0x1c,%esp
80100e57:	5b                   	pop    %ebx
80100e58:	5e                   	pop    %esi
80100e59:	5f                   	pop    %edi
80100e5a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5b:	e9 a0 35 00 00       	jmp    80104400 <release>
    return;
  }
  ff = *f;
80100e60:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e64:	8b 37                	mov    (%edi),%esi
80100e66:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e69:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e75:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7f:	e8 7c 35 00 00       	call   80104400 <release>

  if(ff.type == FD_PIPE)
80100e84:	83 fe 01             	cmp    $0x1,%esi
80100e87:	74 0f                	je     80100e98 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e89:	83 fe 02             	cmp    $0x2,%esi
80100e8c:	74 22                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8e:	83 c4 1c             	add    $0x1c,%esp
80100e91:	5b                   	pop    %ebx
80100e92:	5e                   	pop    %esi
80100e93:	5f                   	pop    %edi
80100e94:	5d                   	pop    %ebp
80100e95:	c3                   	ret    
80100e96:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e9c:	89 1c 24             	mov    %ebx,(%esp)
80100e9f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ea3:	e8 18 26 00 00       	call   801034c0 <pipeclose>
80100ea8:	eb e4                	jmp    80100e8e <fileclose+0x6e>
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 eb 1d 00 00       	call   80102ca0 <begin_op>
    iput(ff.ip);
80100eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb8:	89 04 24             	mov    %eax,(%esp)
80100ebb:	e8 00 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100ec0:	83 c4 1c             	add    $0x1c,%esp
80100ec3:	5b                   	pop    %ebx
80100ec4:	5e                   	pop    %esi
80100ec5:	5f                   	pop    %edi
80100ec6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec7:	e9 44 1e 00 00       	jmp    80102d10 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecc:	c7 04 24 18 73 10 80 	movl   $0x80107318,(%esp)
80100ed3:	e8 88 f4 ff ff       	call   80100360 <panic>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 14             	sub    $0x14,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 b6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 34 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f0c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 69 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f17:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f1a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f1c:	5b                   	pop    %ebx
80100f1d:	5d                   	pop    %ebp
80100f1e:	c3                   	ret    
80100f1f:	90                   	nop
80100f20:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	5b                   	pop    %ebx
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 1c             	sub    $0x1c,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 68                	je     80100fb0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 49                	je     80100f98 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 63                	jne    80100fb7 <fileread+0x87>
    ilock(f->ip);
80100f54:	8b 43 10             	mov    0x10(%ebx),%eax
80100f57:	89 04 24             	mov    %eax,(%esp)
80100f5a:	e8 51 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f63:	8b 43 14             	mov    0x14(%ebx),%eax
80100f66:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 f7 09 00 00       	call   80101970 <readi>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	89 c6                	mov    %eax,%esi
80100f7d:	7e 03                	jle    80100f82 <fileread+0x52>
      f->off += r;
80100f7f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f82:	8b 43 10             	mov    0x10(%ebx),%eax
80100f85:	89 04 24             	mov    %eax,(%esp)
80100f88:	e8 f3 07 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8f:	83 c4 1c             	add    $0x1c,%esp
80100f92:	5b                   	pop    %ebx
80100f93:	5e                   	pop    %esi
80100f94:	5f                   	pop    %edi
80100f95:	5d                   	pop    %ebp
80100f96:	c3                   	ret    
80100f97:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f98:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f9b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9e:	83 c4 1c             	add    $0x1c,%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa5:	e9 c6 26 00 00       	jmp    80103670 <piperead>
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb d8                	jmp    80100f8f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fb7:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
80100fbe:	e8 9d f3 ff ff       	call   80100360 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 2c             	sub    $0x2c,%esp
80100fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fe5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 ae 00 00 00    	je     801010a0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 07                	mov    (%edi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d7 00 00 00    	jne    801010dd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 db                	xor    %ebx,%ebx
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 31                	jg     80101040 <filewrite+0x70>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101018:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010101b:	01 47 14             	add    %eax,0x14(%edi)
8010101e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101021:	89 0c 24             	mov    %ecx,(%esp)
80101024:	e8 57 07 00 00       	call   80101780 <iunlock>
      end_op();
80101029:	e8 e2 1c 00 00       	call   80102d10 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101031:	39 f0                	cmp    %esi,%eax
80101033:	0f 85 98 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101039:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010103e:	7e 70                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101040:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101043:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101048:	29 de                	sub    %ebx,%esi
8010104a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101050:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101053:	e8 48 1c 00 00       	call   80102ca0 <begin_op>
      ilock(f->ip);
80101058:	8b 47 10             	mov    0x10(%edi),%eax
8010105b:	89 04 24             	mov    %eax,(%esp)
8010105e:	e8 4d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101063:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101067:	8b 47 14             	mov    0x14(%edi),%eax
8010106a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	01 d8                	add    %ebx,%eax
80101073:	89 44 24 04          	mov    %eax,0x4(%esp)
80101077:	8b 47 10             	mov    0x10(%edi),%eax
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 2e 0a 00 00       	call   80101ab0 <writei>
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 92                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101086:	8b 4f 10             	mov    0x10(%edi),%ecx
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108c:	89 0c 24             	mov    %ecx,(%esp)
8010108f:	e8 ec 06 00 00       	call   80101780 <iunlock>
      end_op();
80101094:	e8 77 1c 00 00       	call   80102d10 <end_op>

      if(r < 0)
80101099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	74 91                	je     80101031 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
801010ac:	c3                   	ret    
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010b3:	89 d8                	mov    %ebx,%eax
801010b5:	75 e9                	jne    801010a0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010b7:	83 c4 2c             	add    $0x2c,%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 47 0c             	mov    0xc(%edi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	83 c4 2c             	add    $0x2c,%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 7f 24 00 00       	jmp    80103550 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	c7 04 24 2b 73 10 80 	movl   $0x8010732b,(%esp)
801010d8:	e8 83 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010dd:	c7 04 24 31 73 10 80 	movl   $0x80107331,(%esp)
801010e4:	e8 77 f2 ff ff       	call   80100360 <panic>
801010e9:	66 90                	xchg   %ax,%ax
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 2c             	sub    $0x2c,%esp
801010f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010fc:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101101:	85 c0                	test   %eax,%eax
80101103:	0f 84 8c 00 00 00    	je     80101195 <balloc+0xa5>
80101109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101110:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101113:	89 f0                	mov    %esi,%eax
80101115:	c1 f8 0c             	sar    $0xc,%eax
80101118:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010111e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101122:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101125:	89 04 24             	mov    %eax,(%esp)
80101128:	e8 a3 ef ff ff       	call   801000d0 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101138:	31 c0                	xor    %eax,%eax
8010113a:	eb 33                	jmp    8010116f <balloc+0x7f>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101140:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101143:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101145:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	bf 01 00 00 00       	mov    $0x1,%edi
80101152:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101154:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101159:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115b:	0f b6 fb             	movzbl %bl,%edi
8010115e:	85 cf                	test   %ecx,%edi
80101160:	74 46                	je     801011a8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101162:	83 c0 01             	add    $0x1,%eax
80101165:	83 c6 01             	add    $0x1,%esi
80101168:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010116d:	74 05                	je     80101174 <balloc+0x84>
8010116f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101172:	72 cc                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 61 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
8010118f:	0f 82 7b ff ff ff    	jb     80101110 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101195:	c7 04 24 3b 73 10 80 	movl   $0x8010733b,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	09 d9                	or     %ebx,%ecx
801011aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ad:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011b1:	89 1c 24             	mov    %ebx,(%esp)
801011b4:	e8 87 1c 00 00       	call   80102e40 <log_write>
        brelse(bp);
801011b9:	89 1c 24             	mov    %ebx,(%esp)
801011bc:	e8 1f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011c8:	89 04 24             	mov    %eax,(%esp)
801011cb:	e8 00 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011d7:	00 
801011d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011df:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 63 32 00 00       	call   80104450 <memset>
  log_write(bp);
801011ed:	89 1c 24             	mov    %ebx,(%esp)
801011f0:	e8 4b 1c 00 00       	call   80102e40 <log_write>
  brelse(bp);
801011f5:	89 1c 24             	mov    %ebx,(%esp)
801011f8:	e8 e3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fd:	83 c4 2c             	add    $0x2c,%esp
80101200:	89 f0                	mov    %esi,%eax
80101202:	5b                   	pop    %ebx
80101203:	5e                   	pop    %esi
80101204:	5f                   	pop    %edi
80101205:	5d                   	pop    %ebp
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	89 c7                	mov    %eax,%edi
80101216:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101217:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101222:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010122c:	e8 9f 30 00 00       	call   801042d0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101234:	eb 14                	jmp    8010124a <iget+0x3a>
80101236:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101238:	85 f6                	test   %esi,%esi
8010123a:	74 3c                	je     80101278 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101242:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101248:	74 46                	je     80101290 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010124a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010124d:	85 c9                	test   %ecx,%ecx
8010124f:	7e e7                	jle    80101238 <iget+0x28>
80101251:	39 3b                	cmp    %edi,(%ebx)
80101253:	75 e3                	jne    80101238 <iget+0x28>
80101255:	39 53 04             	cmp    %edx,0x4(%ebx)
80101258:	75 de                	jne    80101238 <iget+0x28>
      ip->ref++;
8010125a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010125d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101266:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101269:	e8 92 31 00 00       	call   80104400 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010126e:	83 c4 1c             	add    $0x1c,%esp
80101271:	89 f0                	mov    %esi,%eax
80101273:	5b                   	pop    %ebx
80101274:	5e                   	pop    %esi
80101275:	5f                   	pop    %edi
80101276:	5d                   	pop    %ebp
80101277:	c3                   	ret    
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101289:	75 bf                	jne    8010124a <iget+0x3a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 29                	je     801012bd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101294:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101296:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101299:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012a0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012a7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801012ae:	e8 4d 31 00 00       	call   80104400 <release>

  return ip;
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	89 f0                	mov    %esi,%eax
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012bd:	c7 04 24 51 73 10 80 	movl   $0x80107351,(%esp)
801012c4:	e8 97 f0 ff ff       	call   80100360 <panic>
801012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c3                	mov    %eax,%ebx
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 66                	je     80101350 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	83 c4 1c             	add    $0x1c,%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012fb:	83 fe 7f             	cmp    $0x7f,%esi
801012fe:	77 77                	ja     80101377 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101300:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 5e                	je     80101368 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130e:	8b 03                	mov    (%ebx),%eax
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 b8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101318:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010131e:	8b 32                	mov    (%edx),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	75 19                	jne    8010133d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101324:	8b 03                	mov    (%ebx),%eax
80101326:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101329:	e8 c2 fd ff ff       	call   801010f0 <balloc>
8010132e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101331:	89 02                	mov    %eax,(%edx)
80101333:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101335:	89 3c 24             	mov    %edi,(%esp)
80101338:	e8 03 1b 00 00       	call   80102e40 <log_write>
    }
    brelse(bp);
8010133d:	89 3c 24             	mov    %edi,(%esp)
80101340:	e8 9b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101345:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101348:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 03                	mov    (%ebx),%eax
80101352:	e8 99 fd ff ff       	call   801010f0 <balloc>
80101357:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	e8 81 fd ff ff       	call   801010f0 <balloc>
8010136f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101375:	eb 93                	jmp    8010130a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	c7 04 24 61 73 10 80 	movl   $0x80107361,(%esp)
8010137e:	e8 dd ef ff ff       	call   80100360 <panic>
80101383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 22 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ae:	89 34 24             	mov    %esi,(%esp)
801013b1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013b8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	e8 29 31 00 00       	call   801044f0 <memmove>
  brelse(bp);
801013c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d0:	e9 0b ee ff ff       	jmp    801001e0 <brelse>
801013d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 d7                	mov    %edx,%edi
801013e6:	56                   	push   %esi
801013e7:	53                   	push   %ebx
801013e8:	89 c3                	mov    %eax,%ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ed:	89 04 24             	mov    %eax,(%esp)
801013f0:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801013f7:	80 
801013f8:	e8 93 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013fd:	89 fa                	mov    %edi,%edx
801013ff:	c1 ea 0c             	shr    $0xc,%edx
80101402:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101408:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101410:	89 54 24 04          	mov    %edx,0x4(%esp)
80101414:	e8 b7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010141b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101421:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101423:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101426:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010142b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010142d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101432:	0f b6 c8             	movzbl %al,%ecx
80101435:	85 d9                	test   %ebx,%ecx
80101437:	74 20                	je     80101459 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101439:	f7 d3                	not    %ebx
8010143b:	21 c3                	and    %eax,%ebx
8010143d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 f7 19 00 00       	call   80102e40 <log_write>
  brelse(bp);
80101449:	89 34 24             	mov    %esi,(%esp)
8010144c:	e8 8f ed ff ff       	call   801001e0 <brelse>
}
80101451:	83 c4 1c             	add    $0x1c,%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101459:	c7 04 24 74 73 10 80 	movl   $0x80107374,(%esp)
80101460:	e8 fb ee ff ff       	call   80100360 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 87 73 10 	movl   $0x80107387,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010148b:	e8 c0 2d 00 00       	call   80104250 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 8e 73 10 	movl   $0x8010738e,0x4(%esp)
801014a0:	80 
801014a1:	e8 9a 2c 00 00       	call   80104140 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 cf fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 f8 09 11 80       	mov    0x801109f8,%eax
801014c6:	c7 04 24 ec 73 10 80 	movl   $0x801073ec,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 f4 09 11 80       	mov    0x801109f4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 f0 09 11 80       	mov    0x801109f0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 ec 09 11 80       	mov    0x801109ec,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 e8 09 11 80       	mov    0x801109e8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 e4 09 11 80       	mov    0x801109e4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 a2 2e 00 00       	call   80104450 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 7a 18 00 00       	call   80102e40 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 2f fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 94 73 10 80 	movl   $0x80107394,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 8b 2e 00 00       	call   801044f0 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 d3 17 00 00       	call   80102e40 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101691:	e8 3a 2c 00 00       	call   801042d0 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016a1:	e8 5a 2d 00 00       	call   80104400 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b0 00 00 00    	je     80101773 <ilock+0xc3>
801016c3:	8b 43 08             	mov    0x8(%ebx),%eax
801016c6:	85 c0                	test   %eax,%eax
801016c8:	0f 8e a5 00 00 00    	jle    80101773 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 a7 2a 00 00       	call   80104180 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016d9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016dd:	74 09                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016df:	83 c4 10             	add    $0x10,%esp
801016e2:	5b                   	pop    %ebx
801016e3:	5e                   	pop    %esi
801016e4:	5d                   	pop    %ebp
801016e5:	c3                   	ret    
801016e6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 a0 2d 00 00       	call   801044f0 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101758:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010175c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101761:	0f 85 78 ff ff ff    	jne    801016df <ilock+0x2f>
      panic("ilock: no type");
80101767:	c7 04 24 ac 73 10 80 	movl   $0x801073ac,(%esp)
8010176e:	e8 ed eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101773:	c7 04 24 a6 73 10 80 	movl   $0x801073a6,(%esp)
8010177a:	e8 e1 eb ff ff       	call   80100360 <panic>
8010177f:	90                   	nop

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 86 2a 00 00       	call   80104220 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 2d 2a 00 00       	jmp    801041e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 bb 73 10 80 	movl   $0x801073bb,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)//changed full function
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
 acquire(&icache.lock);
801017cc:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017d3:	e8 f8 2a 00 00       	call   801042d0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017d8:	8b 46 08             	mov    0x8(%esi),%eax
801017db:	83 f8 01             	cmp    $0x1,%eax
801017de:	0f 85 ac 00 00 00    	jne    80101890 <iput+0xd0>
801017e4:	8b 56 4c             	mov    0x4c(%esi),%edx
801017e7:	f6 c2 02             	test   $0x2,%dl
801017ea:	0f 84 a0 00 00 00    	je     80101890 <iput+0xd0>
801017f0:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f5:	0f 85 95 00 00 00    	jne    80101890 <iput+0xd0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
801017fb:	f6 c2 01             	test   $0x1,%dl
801017fe:	0f 85 10 01 00 00    	jne    80101914 <iput+0x154>
      panic("iput busy");
    ip->flags |= I_BUSY;
80101804:	83 ca 01             	or     $0x1,%edx
80101807:	89 56 4c             	mov    %edx,0x4c(%esi)
    release(&icache.lock);
8010180a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101811:	e8 ea 2b 00 00       	call   80104400 <release>
    // Don't need to free block if it is a small file
    if (ip->type != T_SFILE) {
80101816:	66 83 7e 50 04       	cmpw   $0x4,0x50(%esi)
8010181b:	74 47                	je     80101864 <iput+0xa4>
8010181d:	89 f3                	mov    %esi,%ebx
8010181f:	8d 7e 30             	lea    0x30(%esi),%edi
80101822:	eb 0b                	jmp    8010182f <iput+0x6f>
80101824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101828:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010182b:	39 fb                	cmp    %edi,%ebx
8010182d:	74 1c                	je     8010184b <iput+0x8b>
    if(ip->addrs[i]){
8010182f:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101832:	85 d2                	test   %edx,%edx
80101834:	74 f2                	je     80101828 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
80101836:	8b 06                	mov    (%esi),%eax
80101838:	83 c3 04             	add    $0x4,%ebx
8010183b:	e8 a0 fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101840:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101847:	39 fb                	cmp    %edi,%ebx
80101849:	75 e4                	jne    8010182f <iput+0x6f>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
8010184b:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101851:	85 c0                	test   %eax,%eax
80101853:	75 5b                	jne    801018b0 <iput+0xf0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101855:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
8010185c:	89 34 24             	mov    %esi,(%esp)
8010185f:	e8 8c fd ff ff       	call   801015f0 <iupdate>
    release(&icache.lock);
    // Don't need to free block if it is a small file
    if (ip->type != T_SFILE) {
      itrunc(ip);
    }
    ip->type = 0;
80101864:	31 c0                	xor    %eax,%eax
80101866:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010186a:	89 34 24             	mov    %esi,(%esp)
8010186d:	e8 7e fd ff ff       	call   801015f0 <iupdate>
    acquire(&icache.lock);
80101872:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101879:	e8 52 2a 00 00       	call   801042d0 <acquire>
    ip->flags = 0;
8010187e:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    wakeup(ip);
80101885:	89 34 24             	mov    %esi,(%esp)
80101888:	e8 03 27 00 00       	call   80103f90 <wakeup>
8010188d:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
80101890:	83 e8 01             	sub    $0x1,%eax
80101893:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101896:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010189d:	83 c4 1c             	add    $0x1c,%esp
801018a0:	5b                   	pop    %ebx
801018a1:	5e                   	pop    %esi
801018a2:	5f                   	pop    %edi
801018a3:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
801018a4:	e9 57 2b 00 00       	jmp    80104400 <release>
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801018b4:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b6:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 04 24             	mov    %eax,(%esp)
801018bb:	e8 10 e8 ff ff       	call   801000d0 <bread>
801018c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c3:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801018c6:	31 c0                	xor    %eax,%eax
801018c8:	eb 13                	jmp    801018dd <iput+0x11d>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018d0:	83 c3 01             	add    $0x1,%ebx
801018d3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d9:	89 d8                	mov    %ebx,%eax
801018db:	74 10                	je     801018ed <iput+0x12d>
      if(a[j])
801018dd:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e0:	85 d2                	test   %edx,%edx
801018e2:	74 ec                	je     801018d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801018e4:	8b 06                	mov    (%esi),%eax
801018e6:	e8 f5 fa ff ff       	call   801013e0 <bfree>
801018eb:	eb e3                	jmp    801018d0 <iput+0x110>
    }
    brelse(bp);
801018ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f0:	89 04 24             	mov    %eax,(%esp)
801018f3:	e8 e8 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f8:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018fe:	8b 06                	mov    (%esi),%eax
80101900:	e8 db fa ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101905:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010190c:	00 00 00 
8010190f:	e9 41 ff ff ff       	jmp    80101855 <iput+0x95>
{
 acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
80101914:	c7 04 24 c3 73 10 80 	movl   $0x801073c3,(%esp)
8010191b:	e8 40 ea ff ff       	call   80100360 <panic>

80101920 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 4e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n) //full function changed
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	0f b7 50 50          	movzwl 0x50(%eax),%edx

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n) //full function changed
{
80101986:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101989:	8b 7d 14             	mov    0x14(%ebp),%edi
8010198c:	89 45 e0             	mov    %eax,-0x20(%ebp)
uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010198f:	66 83 fa 03          	cmp    $0x3,%dx

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n) //full function changed
{
80101993:	89 7d e4             	mov    %edi,-0x1c(%ebp)
uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101996:	0f 84 bc 00 00 00    	je     80101a58 <readi+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010199c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010199f:	8b 40 58             	mov    0x58(%eax),%eax
801019a2:	39 f0                	cmp    %esi,%eax
801019a4:	0f 82 ee 00 00 00    	jb     80101a98 <readi+0x128>
801019aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ad:	89 fb                	mov    %edi,%ebx
801019af:	01 f3                	add    %esi,%ebx
801019b1:	0f 82 e1 00 00 00    	jb     80101a98 <readi+0x128>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b7:	89 c1                	mov    %eax,%ecx
801019b9:	29 f1                	sub    %esi,%ecx
801019bb:	39 d8                	cmp    %ebx,%eax
801019bd:	0f 43 cf             	cmovae %edi,%ecx

  // 2 cases
  // handle T_SFILE
  if (ip->type == T_SFILE) {
801019c0:	66 83 fa 04          	cmp    $0x4,%dx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  // 2 cases
  // handle T_SFILE
  if (ip->type == T_SFILE) {
801019c7:	0f 84 ac 00 00 00    	je     80101a79 <readi+0x109>
    memmove(dst, (char*)(ip->addrs) + off, n);
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	31 ff                	xor    %edi,%edi
801019cf:	85 c9                	test   %ecx,%ecx
801019d1:	74 76                	je     80101a49 <readi+0xd9>
801019d3:	90                   	nop
801019d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      uint sector_number = bmap(ip, off/BSIZE);
801019d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019db:	89 f2                	mov    %esi,%edx
801019dd:	c1 ea 09             	shr    $0x9,%edx
801019e0:	e8 eb f8 ff ff       	call   801012d0 <bmap>
      if(sector_number == 0){ //failed to find block
801019e5:	85 c0                	test   %eax,%eax
801019e7:	0f 84 b2 00 00 00    	je     80101a9f <readi+0x12f>
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
801019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      m = min(n - tot, BSIZE - off%BSIZE);
801019f4:	bb 00 02 00 00       	mov    $0x200,%ebx
      uint sector_number = bmap(ip, off/BSIZE);
      if(sector_number == 0){ //failed to find block
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
801019f9:	8b 00                	mov    (%eax),%eax
801019fb:	89 04 24             	mov    %eax,(%esp)
801019fe:	e8 cd e6 ff ff       	call   801000d0 <bread>
      m = min(n - tot, BSIZE - off%BSIZE);
80101a03:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a06:	29 f9                	sub    %edi,%ecx
      uint sector_number = bmap(ip, off/BSIZE);
      if(sector_number == 0){ //failed to find block
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
80101a08:	89 c2                	mov    %eax,%edx
      m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	89 f0                	mov    %esi,%eax
80101a0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a11:	29 c3                	sub    %eax,%ebx
      memmove(dst, bp->data + off%BSIZE, m);
80101a13:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
      if(sector_number == 0){ //failed to find block
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
      m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	39 cb                	cmp    %ecx,%ebx
      memmove(dst, bp->data + off%BSIZE, m);
80101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
      if(sector_number == 0){ //failed to find block
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
      m = min(n - tot, BSIZE - off%BSIZE);
80101a20:	0f 47 d9             	cmova  %ecx,%ebx
      memmove(dst, bp->data + off%BSIZE, m);
80101a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  // handle T_SFILE
  if (ip->type == T_SFILE) {
    memmove(dst, (char*)(ip->addrs) + off, n);
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 df                	add    %ebx,%edi
80101a29:	01 de                	add    %ebx,%esi
        panic("readi: trying to read a block that was never allocated");
      }
      
      bp = bread(ip->dev, sector_number);
      m = min(n - tot, BSIZE - off%BSIZE);
      memmove(dst, bp->data + off%BSIZE, m);
80101a2b:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101a2e:	89 04 24             	mov    %eax,(%esp)
80101a31:	e8 ba 2a 00 00       	call   801044f0 <memmove>
      brelse(bp);
80101a36:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101a39:	89 14 24             	mov    %edx,(%esp)
80101a3c:	e8 9f e7 ff ff       	call   801001e0 <brelse>
  // handle T_SFILE
  if (ip->type == T_SFILE) {
    memmove(dst, (char*)(ip->addrs) + off, n);
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a41:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101a44:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a47:	77 8f                	ja     801019d8 <readi+0x68>
      memmove(dst, bp->data + off%BSIZE, m);
      brelse(bp);
    }
  }
  
  return n;
80101a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a4c:	83 c4 2c             	add    $0x2c,%esp
80101a4f:	5b                   	pop    %ebx
80101a50:	5e                   	pop    %esi
80101a51:	5f                   	pop    %edi
80101a52:	5d                   	pop    %ebp
80101a53:	c3                   	ret    
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a58:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a5c:	66 83 f8 09          	cmp    $0x9,%ax
80101a60:	77 36                	ja     80101a98 <readi+0x128>
80101a62:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a69:	85 c0                	test   %eax,%eax
80101a6b:	74 2b                	je     80101a98 <readi+0x128>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a6d:	89 7d 10             	mov    %edi,0x10(%ebp)
      brelse(bp);
    }
  }
  
  return n;
}
80101a70:	83 c4 2c             	add    $0x2c,%esp
80101a73:	5b                   	pop    %ebx
80101a74:	5e                   	pop    %esi
80101a75:	5f                   	pop    %edi
80101a76:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a77:	ff e0                	jmp    *%eax
    n = ip->size - off;

  // 2 cases
  // handle T_SFILE
  if (ip->type == T_SFILE) {
    memmove(dst, (char*)(ip->addrs) + off, n);
80101a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a83:	8d 44 30 5c          	lea    0x5c(%eax,%esi,1),%eax
80101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101a8e:	89 04 24             	mov    %eax,(%esp)
80101a91:	e8 5a 2a 00 00       	call   801044f0 <memmove>
80101a96:	eb b1                	jmp    80101a49 <readi+0xd9>
uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a9d:	eb ad                	jmp    80101a4c <readi+0xdc>
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
      uint sector_number = bmap(ip, off/BSIZE);
      if(sector_number == 0){ //failed to find block
        panic("readi: trying to read a block that was never allocated");
80101a9f:	c7 04 24 40 74 10 80 	movl   $0x80107440,(%esp)
80101aa6:	e8 b5 e8 ff ff       	call   80100360 <panic>
80101aab:	90                   	nop
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 2c             	sub    $0x2c,%esp
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101abf:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ac2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac5:	0f b7 40 50          	movzwl 0x50(%eax),%eax

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ac9:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101acc:	8b 75 10             	mov    0x10(%ebp),%esi
80101acf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ad2:	66 83 f8 03          	cmp    $0x3,%ax
80101ad6:	0f 84 fc 00 00 00    	je     80101bd8 <writei+0x128>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101adc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80101adf:	39 71 58             	cmp    %esi,0x58(%ecx)
80101ae2:	0f 82 98 01 00 00    	jb     80101c80 <writei+0x1d0>
80101ae8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101aeb:	01 f2                	add    %esi,%edx
80101aed:	0f 82 8d 01 00 00    	jb     80101c80 <writei+0x1d0>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101af3:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101af9:	76 0a                	jbe    80101b05 <writei+0x55>
    n = MAXFILE*BSIZE - off;
80101afb:	c7 45 e0 00 18 01 00 	movl   $0x11800,-0x20(%ebp)
80101b02:	29 75 e0             	sub    %esi,-0x20(%ebp)
  // try to make the small file bigger than limit
  if(ip->type == T_SFILE && off + n > (NDIRECT + 1) * sizeof(uint))
80101b05:	66 83 f8 04          	cmp    $0x4,%ax
80101b09:	0f 84 19 01 00 00    	je     80101c28 <writei+0x178>
  if (ip->type == T_SFILE) {
    memmove((char*)(ip->addrs) + off, src, n);
    off += n;
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b19:	85 c0                	test   %eax,%eax
80101b1b:	75 6f                	jne    80101b8c <writei+0xdc>
80101b1d:	e9 ab 00 00 00       	jmp    80101bcd <writei+0x11d>
80101b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(sector_number == 0){ //failed to find block
        n = tot; //return number of bytes written so far
        break;
      }
      
      bp = bread(ip->dev, sector_number);
80101b28:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b2c:	8b 07                	mov    (%edi),%eax
      m = min(n - tot, BSIZE - off%BSIZE);
80101b2e:	bb 00 02 00 00       	mov    $0x200,%ebx
      if(sector_number == 0){ //failed to find block
        n = tot; //return number of bytes written so far
        break;
      }
      
      bp = bread(ip->dev, sector_number);
80101b33:	89 04 24             	mov    %eax,(%esp)
80101b36:	e8 95 e5 ff ff       	call   801000d0 <bread>
      m = min(n - tot, BSIZE - off%BSIZE);
80101b3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b3e:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
      memmove(bp->data + off%BSIZE, src, m);
80101b41:	8b 55 dc             	mov    -0x24(%ebp),%edx
      if(sector_number == 0){ //failed to find block
        n = tot; //return number of bytes written so far
        break;
      }
      
      bp = bread(ip->dev, sector_number);
80101b44:	89 c7                	mov    %eax,%edi
      m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	89 f0                	mov    %esi,%eax
80101b48:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b4d:	29 c3                	sub    %eax,%ebx
80101b4f:	39 cb                	cmp    %ecx,%ebx
80101b51:	0f 47 d9             	cmova  %ecx,%ebx
      memmove(bp->data + off%BSIZE, src, m);
80101b54:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if (ip->type == T_SFILE) {
    memmove((char*)(ip->addrs) + off, src, n);
    off += n;
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 de                	add    %ebx,%esi
        break;
      }
      
      bp = bread(ip->dev, sector_number);
      m = min(n - tot, BSIZE - off%BSIZE);
      memmove(bp->data + off%BSIZE, src, m);
80101b5a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b62:	89 04 24             	mov    %eax,(%esp)
80101b65:	e8 86 29 00 00       	call   801044f0 <memmove>
      bwrite(bp);
80101b6a:	89 3c 24             	mov    %edi,(%esp)
80101b6d:	e8 2e e6 ff ff       	call   801001a0 <bwrite>
      brelse(bp);
80101b72:	89 3c 24             	mov    %edi,(%esp)
80101b75:	e8 66 e6 ff ff       	call   801001e0 <brelse>
  if (ip->type == T_SFILE) {
    memmove((char*)(ip->addrs) + off, src, n);
    off += n;
  } else {
    // handle T_FILE
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b7a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b80:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b83:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b86:	0f 86 7c 00 00 00    	jbe    80101c08 <writei+0x158>
      uint sector_number = bmap(ip, off/BSIZE);
80101b8c:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b8f:	89 f2                	mov    %esi,%edx
80101b91:	c1 ea 09             	shr    $0x9,%edx
80101b94:	89 f8                	mov    %edi,%eax
80101b96:	e8 35 f7 ff ff       	call   801012d0 <bmap>
      if(sector_number == 0){ //failed to find block
80101b9b:	85 c0                	test   %eax,%eax
80101b9d:	75 89                	jne    80101b28 <writei+0x78>
      brelse(bp);
    }
  }

  // If SMALLFILE, must update inode
  if(ip->type == T_SFILE || (n > 0 && off > ip->size)) {
80101b9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba2:	66 83 78 50 04       	cmpw   $0x4,0x50(%eax)
80101ba7:	0f 84 c5 00 00 00    	je     80101c72 <writei+0x1c2>
80101bad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101bb0:	85 c9                	test   %ecx,%ecx
80101bb2:	74 19                	je     80101bcd <writei+0x11d>
80101bb4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bb7:	39 70 58             	cmp    %esi,0x58(%eax)
80101bba:	73 11                	jae    80101bcd <writei+0x11d>
    if (n > 0 && off > ip->size) {
      ip->size = off;
80101bbc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbf:	89 70 58             	mov    %esi,0x58(%eax)
    }
    iupdate(ip); 
80101bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bc5:	89 04 24             	mov    %eax,(%esp)
80101bc8:	e8 23 fa ff ff       	call   801015f0 <iupdate>
  }
  return n;
80101bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd0:	83 c4 2c             	add    $0x2c,%esp
80101bd3:	5b                   	pop    %ebx
80101bd4:	5e                   	pop    %esi
80101bd5:	5f                   	pop    %edi
80101bd6:	5d                   	pop    %ebp
80101bd7:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd8:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101bdb:	0f bf 46 52          	movswl 0x52(%esi),%eax
80101bdf:	66 83 f8 09          	cmp    $0x9,%ax
80101be3:	0f 87 97 00 00 00    	ja     80101c80 <writei+0x1d0>
80101be9:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101bf0:	85 c0                	test   %eax,%eax
80101bf2:	0f 84 88 00 00 00    	je     80101c80 <writei+0x1d0>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bf8:	89 4d 10             	mov    %ecx,0x10(%ebp)
      ip->size = off;
    }
    iupdate(ip); 
  }
  return n;
}
80101bfb:	83 c4 2c             	add    $0x2c,%esp
80101bfe:	5b                   	pop    %ebx
80101bff:	5e                   	pop    %esi
80101c00:	5f                   	pop    %edi
80101c01:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c02:	ff e0                	jmp    *%eax
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      brelse(bp);
    }
  }

  // If SMALLFILE, must update inode
  if(ip->type == T_SFILE || (n > 0 && off > ip->size)) {
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0b:	66 83 78 50 04       	cmpw   $0x4,0x50(%eax)
80101c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101c16:	75 9c                	jne    80101bb4 <writei+0x104>
    if (n > 0 && off > ip->size) {
80101c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1b:	39 70 58             	cmp    %esi,0x58(%eax)
80101c1e:	73 a2                	jae    80101bc2 <writei+0x112>
80101c20:	eb 9a                	jmp    80101bbc <writei+0x10c>
80101c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c2b:	8d 1c 30             	lea    (%eax,%esi,1),%ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  // try to make the small file bigger than limit
  if(ip->type == T_SFILE && off + n > (NDIRECT + 1) * sizeof(uint))
80101c2e:	83 fb 34             	cmp    $0x34,%ebx
80101c31:	76 0f                	jbe    80101c42 <writei+0x192>
    n = (NDIRECT + 1) * sizeof(uint) - off;
80101c33:	c7 45 e0 34 00 00 00 	movl   $0x34,-0x20(%ebp)
80101c3a:	bb 34 00 00 00       	mov    $0x34,%ebx
80101c3f:	29 75 e0             	sub    %esi,-0x20(%ebp)
    
  // 2 cases
  // handle T_SFILE
  if (ip->type == T_SFILE) {
    memmove((char*)(ip->addrs) + off, src, n);
80101c42:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4f:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c53:	8d 44 30 5c          	lea    0x5c(%eax,%esi,1),%eax
    off += n;
80101c57:	89 de                	mov    %ebx,%esi
    n = (NDIRECT + 1) * sizeof(uint) - off;
    
  // 2 cases
  // handle T_SFILE
  if (ip->type == T_SFILE) {
    memmove((char*)(ip->addrs) + off, src, n);
80101c59:	89 04 24             	mov    %eax,(%esp)
80101c5c:	e8 8f 28 00 00       	call   801044f0 <memmove>
      brelse(bp);
    }
  }

  // If SMALLFILE, must update inode
  if(ip->type == T_SFILE || (n > 0 && off > ip->size)) {
80101c61:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c64:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c67:	66 83 78 50 04       	cmpw   $0x4,0x50(%eax)
80101c6c:	0f 85 3b ff ff ff    	jne    80101bad <writei+0xfd>
    if (n > 0 && off > ip->size) {
80101c72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c75:	85 d2                	test   %edx,%edx
80101c77:	0f 84 45 ff ff ff    	je     80101bc2 <writei+0x112>
80101c7d:	eb 99                	jmp    80101c18 <writei+0x168>
80101c7f:	90                   	nop
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c85:	e9 46 ff ff ff       	jmp    80101bd0 <writei+0x120>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ca0:	00 
80101ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca8:	89 04 24             	mov    %eax,(%esp)
80101cab:	e8 c0 28 00 00       	call   80104570 <strncmp>
}
80101cb0:	c9                   	leave  
80101cb1:	c3                   	ret    
80101cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 2c             	sub    $0x2c,%esp
80101cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ccc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd1:	0f 85 97 00 00 00    	jne    80101d6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cda:	31 ff                	xor    %edi,%edi
80101cdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cdf:	85 d2                	test   %edx,%edx
80101ce1:	75 0d                	jne    80101cf0 <dirlookup+0x30>
80101ce3:	eb 73                	jmp    80101d58 <dirlookup+0x98>
80101ce5:	8d 76 00             	lea    0x0(%esi),%esi
80101ce8:	83 c7 10             	add    $0x10,%edi
80101ceb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101cee:	76 68                	jbe    80101d58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101cf7:	00 
80101cf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101cfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101d00:	89 1c 24             	mov    %ebx,(%esp)
80101d03:	e8 68 fc ff ff       	call   80101970 <readi>
80101d08:	83 f8 10             	cmp    $0x10,%eax
80101d0b:	75 55                	jne    80101d62 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101d0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d12:	74 d4                	je     80101ce8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101d14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d25:	00 
80101d26:	89 04 24             	mov    %eax,(%esp)
80101d29:	e8 42 28 00 00       	call   80104570 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	75 b6                	jne    80101ce8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101d32:	8b 45 10             	mov    0x10(%ebp),%eax
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 05                	je     80101d3e <dirlookup+0x7e>
        *poff = off;
80101d39:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d42:	8b 03                	mov    (%ebx),%eax
80101d44:	e8 c7 f4 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101d49:	83 c4 2c             	add    $0x2c,%esp
80101d4c:	5b                   	pop    %ebx
80101d4d:	5e                   	pop    %esi
80101d4e:	5f                   	pop    %edi
80101d4f:	5d                   	pop    %ebp
80101d50:	c3                   	ret    
80101d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d58:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101d5b:	31 c0                	xor    %eax,%eax
}
80101d5d:	5b                   	pop    %ebx
80101d5e:	5e                   	pop    %esi
80101d5f:	5f                   	pop    %edi
80101d60:	5d                   	pop    %ebp
80101d61:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101d62:	c7 04 24 df 73 10 80 	movl   $0x801073df,(%esp)
80101d69:	e8 f2 e5 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101d6e:	c7 04 24 cd 73 10 80 	movl   $0x801073cd,(%esp)
80101d75:	e8 e6 e5 ff ff       	call   80100360 <panic>
80101d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	89 cf                	mov    %ecx,%edi
80101d86:	56                   	push   %esi
80101d87:	53                   	push   %ebx
80101d88:	89 c3                	mov    %eax,%ebx
80101d8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d93:	0f 84 51 01 00 00    	je     80101eea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101d9f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101da2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101da9:	e8 22 25 00 00       	call   801042d0 <acquire>
  ip->ref++;
80101dae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101db9:	e8 42 26 00 00       	call   80104400 <release>
80101dbe:	eb 03                	jmp    80101dc3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101dc0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101dc3:	0f b6 03             	movzbl (%ebx),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x40>
    path++;
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ed 00 00 00    	je     80101ebf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 03             	movzbl (%ebx),%eax
80101dd5:	89 da                	mov    %ebx,%edx
80101dd7:	84 c0                	test   %al,%al
80101dd9:	0f 84 b1 00 00 00    	je     80101e90 <namex+0x110>
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	75 0f                	jne    80101df2 <namex+0x72>
80101de3:	e9 a8 00 00 00       	jmp    80101e90 <namex+0x110>
80101de8:	3c 2f                	cmp    $0x2f,%al
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101df0:	74 0a                	je     80101dfc <namex+0x7c>
    path++;
80101df2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101df5:	0f b6 02             	movzbl (%edx),%eax
80101df8:	84 c0                	test   %al,%al
80101dfa:	75 ec                	jne    80101de8 <namex+0x68>
80101dfc:	89 d1                	mov    %edx,%ecx
80101dfe:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101e00:	83 f9 0d             	cmp    $0xd,%ecx
80101e03:	0f 8e 8f 00 00 00    	jle    80101e98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101e09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e14:	00 
80101e15:	89 3c 24             	mov    %edi,(%esp)
80101e18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e1b:	e8 d0 26 00 00       	call   801044f0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e28:	75 0e                	jne    80101e38 <namex+0xb8>
80101e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101e30:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e36:	74 f8                	je     80101e30 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e38:	89 34 24             	mov    %esi,(%esp)
80101e3b:	e8 70 f8 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101e40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e45:	0f 85 85 00 00 00    	jne    80101ed0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4e:	85 d2                	test   %edx,%edx
80101e50:	74 09                	je     80101e5b <namex+0xdb>
80101e52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e55:	0f 84 a5 00 00 00    	je     80101f00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e62:	00 
80101e63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101e67:	89 34 24             	mov    %esi,(%esp)
80101e6a:	e8 51 fe ff ff       	call   80101cc0 <dirlookup>
80101e6f:	85 c0                	test   %eax,%eax
80101e71:	74 5d                	je     80101ed0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e73:	89 34 24             	mov    %esi,(%esp)
80101e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e79:	e8 02 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101e7e:	89 34 24             	mov    %esi,(%esp)
80101e81:	e8 3a f9 ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e89:	89 c6                	mov    %eax,%esi
80101e8b:	e9 33 ff ff ff       	jmp    80101dc3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e90:	31 c9                	xor    %ecx,%ecx
80101e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ea0:	89 3c 24             	mov    %edi,(%esp)
80101ea3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ea6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ea9:	e8 42 26 00 00       	call   801044f0 <memmove>
    name[len] = 0;
80101eae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101eb4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101eb8:	89 d3                	mov    %edx,%ebx
80101eba:	e9 66 ff ff ff       	jmp    80101e25 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec2:	85 c0                	test   %eax,%eax
80101ec4:	75 4c                	jne    80101f12 <namex+0x192>
80101ec6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101ec8:	83 c4 2c             	add    $0x2c,%esp
80101ecb:	5b                   	pop    %ebx
80101ecc:	5e                   	pop    %esi
80101ecd:	5f                   	pop    %edi
80101ece:	5d                   	pop    %ebp
80101ecf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101ed0:	89 34 24             	mov    %esi,(%esp)
80101ed3:	e8 a8 f8 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101ed8:	89 34 24             	mov    %esi,(%esp)
80101edb:	e8 e0 f8 ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ee0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101ee3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ee5:	5b                   	pop    %ebx
80101ee6:	5e                   	pop    %esi
80101ee7:	5f                   	pop    %edi
80101ee8:	5d                   	pop    %ebp
80101ee9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101eea:	ba 01 00 00 00       	mov    $0x1,%edx
80101eef:	b8 01 00 00 00       	mov    $0x1,%eax
80101ef4:	e8 17 f3 ff ff       	call   80101210 <iget>
80101ef9:	89 c6                	mov    %eax,%esi
80101efb:	e9 c3 fe ff ff       	jmp    80101dc3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101f00:	89 34 24             	mov    %esi,(%esp)
80101f03:	e8 78 f8 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f08:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101f0b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0d:	5b                   	pop    %ebx
80101f0e:	5e                   	pop    %esi
80101f0f:	5f                   	pop    %edi
80101f10:	5d                   	pop    %ebp
80101f11:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101f12:	89 34 24             	mov    %esi,(%esp)
80101f15:	e8 a6 f8 ff ff       	call   801017c0 <iput>
    return 0;
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb aa                	jmp    80101ec8 <namex+0x148>
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 2c             	sub    $0x2c,%esp
80101f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101f36:	00 
80101f37:	89 1c 24             	mov    %ebx,(%esp)
80101f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f3e:	e8 7d fd ff ff       	call   80101cc0 <dirlookup>
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 85 8b 00 00 00    	jne    80101fd6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101f4e:	31 ff                	xor    %edi,%edi
80101f50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f53:	85 c0                	test   %eax,%eax
80101f55:	75 13                	jne    80101f6a <dirlink+0x4a>
80101f57:	eb 35                	jmp    80101f8e <dirlink+0x6e>
80101f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f60:	8d 57 10             	lea    0x10(%edi),%edx
80101f63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101f66:	89 d7                	mov    %edx,%edi
80101f68:	76 24                	jbe    80101f8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f71:	00 
80101f72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f7a:	89 1c 24             	mov    %ebx,(%esp)
80101f7d:	e8 ee f9 ff ff       	call   80101970 <readi>
80101f82:	83 f8 10             	cmp    $0x10,%eax
80101f85:	75 5e                	jne    80101fe5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101f87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f8c:	75 d2                	jne    80101f60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101f98:	00 
80101f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fa0:	89 04 24             	mov    %eax,(%esp)
80101fa3:	e8 38 26 00 00       	call   801045e0 <strncpy>
  de.inum = inum;
80101fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101fb2:	00 
80101fb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101fb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101fbb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101fbe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc2:	e8 e9 fa ff ff       	call   80101ab0 <writei>
80101fc7:	83 f8 10             	cmp    $0x10,%eax
80101fca:	75 25                	jne    80101ff1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101fcc:	31 c0                	xor    %eax,%eax
}
80101fce:	83 c4 2c             	add    $0x2c,%esp
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101fd6:	89 04 24             	mov    %eax,(%esp)
80101fd9:	e8 e2 f7 ff ff       	call   801017c0 <iput>
    return -1;
80101fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe3:	eb e9                	jmp    80101fce <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101fe5:	c7 04 24 df 73 10 80 	movl   $0x801073df,(%esp)
80101fec:	e8 6f e3 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ff1:	c7 04 24 e2 79 10 80 	movl   $0x801079e2,(%esp)
80101ff8:	e8 63 e3 ff ff       	call   80100360 <panic>
80101ffd:	8d 76 00             	lea    0x0(%esi),%esi

80102000 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102000:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102001:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102003:	89 e5                	mov    %esp,%ebp
80102005:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102008:	8b 45 08             	mov    0x8(%ebp),%eax
8010200b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010200e:	e8 6d fd ff ff       	call   80101d80 <namex>
}
80102013:	c9                   	leave  
80102014:	c3                   	ret    
80102015:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102020:	55                   	push   %ebp
  return namex(path, 1, name);
80102021:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102026:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010202e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010202f:	e9 4c fd ff ff       	jmp    80101d80 <namex>
80102034:	66 90                	xchg   %ax,%ax
80102036:	66 90                	xchg   %ax,%ax
80102038:	66 90                	xchg   %ax,%ax
8010203a:	66 90                	xchg   %ax,%ax
8010203c:	66 90                	xchg   %ax,%ax
8010203e:	66 90                	xchg   %ax,%ax

80102040 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	56                   	push   %esi
80102044:	89 c6                	mov    %eax,%esi
80102046:	53                   	push   %ebx
80102047:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
8010204a:	85 c0                	test   %eax,%eax
8010204c:	0f 84 99 00 00 00    	je     801020eb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102052:	8b 48 08             	mov    0x8(%eax),%ecx
80102055:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
8010205b:	0f 87 7e 00 00 00    	ja     801020df <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102061:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102066:	66 90                	xchg   %ax,%ax
80102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	83 e0 c0             	and    $0xffffffc0,%eax
8010206c:	3c 40                	cmp    $0x40,%al
8010206e:	75 f8                	jne    80102068 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102070:	31 db                	xor    %ebx,%ebx
80102072:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102077:	89 d8                	mov    %ebx,%eax
80102079:	ee                   	out    %al,(%dx)
8010207a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010207f:	b8 01 00 00 00       	mov    $0x1,%eax
80102084:	ee                   	out    %al,(%dx)
80102085:	0f b6 c1             	movzbl %cl,%eax
80102088:	b2 f3                	mov    $0xf3,%dl
8010208a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010208b:	89 c8                	mov    %ecx,%eax
8010208d:	b2 f4                	mov    $0xf4,%dl
8010208f:	c1 f8 08             	sar    $0x8,%eax
80102092:	ee                   	out    %al,(%dx)
80102093:	b2 f5                	mov    $0xf5,%dl
80102095:	89 d8                	mov    %ebx,%eax
80102097:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102098:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010209c:	b2 f6                	mov    $0xf6,%dl
8010209e:	83 e0 01             	and    $0x1,%eax
801020a1:	c1 e0 04             	shl    $0x4,%eax
801020a4:	83 c8 e0             	or     $0xffffffe0,%eax
801020a7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020a8:	f6 06 04             	testb  $0x4,(%esi)
801020ab:	75 13                	jne    801020c0 <idestart+0x80>
801020ad:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b2:	b8 20 00 00 00       	mov    $0x20,%eax
801020b7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020b8:	83 c4 10             	add    $0x10,%esp
801020bb:	5b                   	pop    %ebx
801020bc:	5e                   	pop    %esi
801020bd:	5d                   	pop    %ebp
801020be:	c3                   	ret    
801020bf:	90                   	nop
801020c0:	b2 f7                	mov    $0xf7,%dl
801020c2:	b8 30 00 00 00       	mov    $0x30,%eax
801020c7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801020c8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801020cd:	83 c6 5c             	add    $0x5c,%esi
801020d0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020d5:	fc                   	cld    
801020d6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020d8:	83 c4 10             	add    $0x10,%esp
801020db:	5b                   	pop    %ebx
801020dc:	5e                   	pop    %esi
801020dd:	5d                   	pop    %ebp
801020de:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801020df:	c7 04 24 80 74 10 80 	movl   $0x80107480,(%esp)
801020e6:	e8 75 e2 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801020eb:	c7 04 24 77 74 10 80 	movl   $0x80107477,(%esp)
801020f2:	e8 69 e2 ff ff       	call   80100360 <panic>
801020f7:	89 f6                	mov    %esi,%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102100 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102106:	c7 44 24 04 92 74 10 	movl   $0x80107492,0x4(%esp)
8010210d:	80 
8010210e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102115:	e8 36 21 00 00       	call   80104250 <initlock>
  picenable(IRQ_IDE);
8010211a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102121:	e8 ea 11 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102126:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010212b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102132:	83 e8 01             	sub    $0x1,%eax
80102135:	89 44 24 04          	mov    %eax,0x4(%esp)
80102139:	e8 82 02 00 00       	call   801023c0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010213e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102148:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102149:	83 e0 c0             	and    $0xffffffc0,%eax
8010214c:	3c 40                	cmp    $0x40,%al
8010214e:	75 f8                	jne    80102148 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102150:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102155:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010215a:	ee                   	out    %al,(%dx)
8010215b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102160:	b2 f7                	mov    $0xf7,%dl
80102162:	eb 09                	jmp    8010216d <ideinit+0x6d>
80102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102168:	83 e9 01             	sub    $0x1,%ecx
8010216b:	74 0f                	je     8010217c <ideinit+0x7c>
8010216d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010216e:	84 c0                	test   %al,%al
80102170:	74 f6                	je     80102168 <ideinit+0x68>
      havedisk1 = 1;
80102172:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102179:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102181:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102186:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102187:	c9                   	leave  
80102188:	c3                   	ret    
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102199:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021a0:	e8 2b 21 00 00       	call   801042d0 <acquire>
  if((b = idequeue) == 0){
801021a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021ab:	85 db                	test   %ebx,%ebx
801021ad:	74 30                	je     801021df <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
801021af:	8b 43 58             	mov    0x58(%ebx),%eax
801021b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801021b7:	8b 33                	mov    (%ebx),%esi
801021b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021bf:	74 37                	je     801021f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
801021c4:	83 ce 02             	or     $0x2,%esi
801021c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021c9:	89 1c 24             	mov    %ebx,(%esp)
801021cc:	e8 bf 1d 00 00       	call   80103f90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d6:	85 c0                	test   %eax,%eax
801021d8:	74 05                	je     801021df <ideintr+0x4f>
    idestart(idequeue);
801021da:	e8 61 fe ff ff       	call   80102040 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801021df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021e6:	e8 15 22 00 00       	call   80104400 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801021eb:	83 c4 1c             	add    $0x1c,%esp
801021ee:	5b                   	pop    %ebx
801021ef:	5e                   	pop    %esi
801021f0:	5f                   	pop    %edi
801021f1:	5d                   	pop    %ebp
801021f2:	c3                   	ret    
801021f3:	90                   	nop
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021fd:	8d 76 00             	lea    0x0(%esi),%esi
80102200:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102201:	89 c1                	mov    %eax,%ecx
80102203:	83 e1 c0             	and    $0xffffffc0,%ecx
80102206:	80 f9 40             	cmp    $0x40,%cl
80102209:	75 f5                	jne    80102200 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010220b:	a8 21                	test   $0x21,%al
8010220d:	75 b2                	jne    801021c1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010220f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102212:	b9 80 00 00 00       	mov    $0x80,%ecx
80102217:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010221c:	fc                   	cld    
8010221d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010221f:	8b 33                	mov    (%ebx),%esi
80102221:	eb 9e                	jmp    801021c1 <ideintr+0x31>
80102223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102230 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	53                   	push   %ebx
80102234:	83 ec 14             	sub    $0x14,%esp
80102237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010223a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010223d:	89 04 24             	mov    %eax,(%esp)
80102240:	e8 db 1f 00 00       	call   80104220 <holdingsleep>
80102245:	85 c0                	test   %eax,%eax
80102247:	0f 84 9e 00 00 00    	je     801022eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010224d:	8b 03                	mov    (%ebx),%eax
8010224f:	83 e0 06             	and    $0x6,%eax
80102252:	83 f8 02             	cmp    $0x2,%eax
80102255:	0f 84 a8 00 00 00    	je     80102303 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010225b:	8b 53 04             	mov    0x4(%ebx),%edx
8010225e:	85 d2                	test   %edx,%edx
80102260:	74 0d                	je     8010226f <iderw+0x3f>
80102262:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102267:	85 c0                	test   %eax,%eax
80102269:	0f 84 88 00 00 00    	je     801022f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010226f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102276:	e8 55 20 00 00       	call   801042d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010227b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102280:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102287:	85 c0                	test   %eax,%eax
80102289:	75 07                	jne    80102292 <iderw+0x62>
8010228b:	eb 4e                	jmp    801022db <iderw+0xab>
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
80102290:	89 d0                	mov    %edx,%eax
80102292:	8b 50 58             	mov    0x58(%eax),%edx
80102295:	85 d2                	test   %edx,%edx
80102297:	75 f7                	jne    80102290 <iderw+0x60>
80102299:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010229c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010229e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022a4:	74 3c                	je     801022e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022a6:	8b 03                	mov    (%ebx),%eax
801022a8:	83 e0 06             	and    $0x6,%eax
801022ab:	83 f8 02             	cmp    $0x2,%eax
801022ae:	74 1a                	je     801022ca <iderw+0x9a>
    sleep(b, &idelock);
801022b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801022b7:	80 
801022b8:	89 1c 24             	mov    %ebx,(%esp)
801022bb:	e8 30 1b 00 00       	call   80103df0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022c0:	8b 13                	mov    (%ebx),%edx
801022c2:	83 e2 06             	and    $0x6,%edx
801022c5:	83 fa 02             	cmp    $0x2,%edx
801022c8:	75 e6                	jne    801022b0 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801022ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022d1:	83 c4 14             	add    $0x14,%esp
801022d4:	5b                   	pop    %ebx
801022d5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801022d6:	e9 25 21 00 00       	jmp    80104400 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801022e0:	eb ba                	jmp    8010229c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801022e2:	89 d8                	mov    %ebx,%eax
801022e4:	e8 57 fd ff ff       	call   80102040 <idestart>
801022e9:	eb bb                	jmp    801022a6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801022eb:	c7 04 24 96 74 10 80 	movl   $0x80107496,(%esp)
801022f2:	e8 69 e0 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801022f7:	c7 04 24 c1 74 10 80 	movl   $0x801074c1,(%esp)
801022fe:	e8 5d e0 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102303:	c7 04 24 ac 74 10 80 	movl   $0x801074ac,(%esp)
8010230a:	e8 51 e0 ff ff       	call   80100360 <panic>
8010230f:	90                   	nop

80102310 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102310:	a1 84 27 11 80       	mov    0x80112784,%eax
80102315:	85 c0                	test   %eax,%eax
80102317:	0f 84 9b 00 00 00    	je     801023b8 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010231d:	55                   	push   %ebp
8010231e:	89 e5                	mov    %esp,%ebp
80102320:	56                   	push   %esi
80102321:	53                   	push   %ebx
80102322:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102325:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010232c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010232f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102336:	00 00 00 
  return ioapic->data;
80102339:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010233f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102342:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102348:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010234e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102355:	c1 e8 10             	shr    $0x10,%eax
80102358:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010235b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010235e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102361:	39 c2                	cmp    %eax,%edx
80102363:	74 12                	je     80102377 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102365:	c7 04 24 e0 74 10 80 	movl   $0x801074e0,(%esp)
8010236c:	e8 df e2 ff ff       	call   80100650 <cprintf>
80102371:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102377:	ba 10 00 00 00       	mov    $0x10,%edx
8010237c:	31 c0                	xor    %eax,%eax
8010237e:	eb 02                	jmp    80102382 <ioapicinit+0x72>
80102380:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102382:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102384:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010238a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010238d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102393:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102396:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102399:	8d 4a 01             	lea    0x1(%edx),%ecx
8010239c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010239f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801023a1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801023a7:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801023a9:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801023b0:	7d ce                	jge    80102380 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023b2:	83 c4 10             	add    $0x10,%esp
801023b5:	5b                   	pop    %ebx
801023b6:	5e                   	pop    %esi
801023b7:	5d                   	pop    %ebp
801023b8:	f3 c3                	repz ret 
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801023c0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801023c6:	55                   	push   %ebp
801023c7:	89 e5                	mov    %esp,%ebp
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801023cc:	85 d2                	test   %edx,%edx
801023ce:	74 29                	je     801023f9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023d0:	8d 48 20             	lea    0x20(%eax),%ecx
801023d3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023d7:	a1 54 26 11 80       	mov    0x80112654,%eax
801023dc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801023de:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023e3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801023e6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023ec:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801023ee:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023f3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801023f6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	66 90                	xchg   %ax,%ax
801023fd:	66 90                	xchg   %ax,%ax
801023ff:	90                   	nop

80102400 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	53                   	push   %ebx
80102404:	83 ec 14             	sub    $0x14,%esp
80102407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010240a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102410:	75 7c                	jne    8010248e <kfree+0x8e>
80102412:	81 fb 88 55 11 80    	cmp    $0x80115588,%ebx
80102418:	72 74                	jb     8010248e <kfree+0x8e>
8010241a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102420:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102425:	77 67                	ja     8010248e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102427:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010242e:	00 
8010242f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102436:	00 
80102437:	89 1c 24             	mov    %ebx,(%esp)
8010243a:	e8 11 20 00 00       	call   80104450 <memset>

  if(kmem.use_lock)
8010243f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102445:	85 d2                	test   %edx,%edx
80102447:	75 37                	jne    80102480 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102449:	a1 98 26 11 80       	mov    0x80112698,%eax
8010244e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102450:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102455:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010245b:	85 c0                	test   %eax,%eax
8010245d:	75 09                	jne    80102468 <kfree+0x68>
    release(&kmem.lock);
}
8010245f:	83 c4 14             	add    $0x14,%esp
80102462:	5b                   	pop    %ebx
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102468:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010246f:	83 c4 14             	add    $0x14,%esp
80102472:	5b                   	pop    %ebx
80102473:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102474:	e9 87 1f 00 00       	jmp    80104400 <release>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102480:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102487:	e8 44 1e 00 00       	call   801042d0 <acquire>
8010248c:	eb bb                	jmp    80102449 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010248e:	c7 04 24 12 75 10 80 	movl   $0x80107512,(%esp)
80102495:	e8 c6 de ff ff       	call   80100360 <panic>
8010249a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024a0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801024ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 08                	jae    801024cc <freerange+0x2c>
801024c4:	eb 18                	jmp    801024de <freerange+0x3e>
801024c6:	66 90                	xchg   %ax,%ax
801024c8:	89 da                	mov    %ebx,%edx
801024ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024cc:	89 14 24             	mov    %edx,(%esp)
801024cf:	e8 2c ff ff ff       	call   80102400 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024da:	39 f0                	cmp    %esi,%eax
801024dc:	76 ea                	jbe    801024c8 <freerange+0x28>
    kfree(p);
}
801024de:	83 c4 10             	add    $0x10,%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	56                   	push   %esi
801024f4:	53                   	push   %ebx
801024f5:	83 ec 10             	sub    $0x10,%esp
801024f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024fb:	c7 44 24 04 18 75 10 	movl   $0x80107518,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
8010250a:	e8 41 1d 00 00       	call   80104250 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010250f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102512:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102519:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010251c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102522:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102528:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010252e:	39 de                	cmp    %ebx,%esi
80102530:	73 0a                	jae    8010253c <kinit1+0x4c>
80102532:	eb 1a                	jmp    8010254e <kinit1+0x5e>
80102534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102538:	89 da                	mov    %ebx,%edx
8010253a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010253c:	89 14 24             	mov    %edx,(%esp)
8010253f:	e8 bc fe ff ff       	call   80102400 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102544:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010254a:	39 c6                	cmp    %eax,%esi
8010254c:	73 ea                	jae    80102538 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010254e:	83 c4 10             	add    $0x10,%esp
80102551:	5b                   	pop    %ebx
80102552:	5e                   	pop    %esi
80102553:	5d                   	pop    %ebp
80102554:	c3                   	ret    
80102555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
80102565:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102568:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010256b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010256e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102574:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 08                	jae    8010258c <kinit2+0x2c>
80102584:	eb 18                	jmp    8010259e <kinit2+0x3e>
80102586:	66 90                	xchg   %ax,%ax
80102588:	89 da                	mov    %ebx,%edx
8010258a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010258c:	89 14 24             	mov    %edx,(%esp)
8010258f:	e8 6c fe ff ff       	call   80102400 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102594:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010259a:	39 c6                	cmp    %eax,%esi
8010259c:	73 ea                	jae    80102588 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010259e:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801025a5:	00 00 00 
}
801025a8:	83 c4 10             	add    $0x10,%esp
801025ab:	5b                   	pop    %ebx
801025ac:	5e                   	pop    %esi
801025ad:	5d                   	pop    %ebp
801025ae:	c3                   	ret    
801025af:	90                   	nop

801025b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801025b7:	a1 94 26 11 80       	mov    0x80112694,%eax
801025bc:	85 c0                	test   %eax,%eax
801025be:	75 30                	jne    801025f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025c0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 08                	je     801025d2 <kalloc+0x22>
    kmem.freelist = r->next;
801025ca:	8b 13                	mov    (%ebx),%edx
801025cc:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801025d2:	85 c0                	test   %eax,%eax
801025d4:	74 0c                	je     801025e2 <kalloc+0x32>
    release(&kmem.lock);
801025d6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801025dd:	e8 1e 1e 00 00       	call   80104400 <release>
  return (char*)r;
}
801025e2:	83 c4 14             	add    $0x14,%esp
801025e5:	89 d8                	mov    %ebx,%eax
801025e7:	5b                   	pop    %ebx
801025e8:	5d                   	pop    %ebp
801025e9:	c3                   	ret    
801025ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025f0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801025f7:	e8 d4 1c 00 00       	call   801042d0 <acquire>
801025fc:	a1 94 26 11 80       	mov    0x80112694,%eax
80102601:	eb bd                	jmp    801025c0 <kalloc+0x10>
80102603:	66 90                	xchg   %ax,%ax
80102605:	66 90                	xchg   %ax,%ax
80102607:	66 90                	xchg   %ax,%ax
80102609:	66 90                	xchg   %ax,%ax
8010260b:	66 90                	xchg   %ax,%ax
8010260d:	66 90                	xchg   %ax,%ax
8010260f:	90                   	nop

80102610 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102610:	ba 64 00 00 00       	mov    $0x64,%edx
80102615:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102616:	a8 01                	test   $0x1,%al
80102618:	0f 84 ba 00 00 00    	je     801026d8 <kbdgetc+0xc8>
8010261e:	b2 60                	mov    $0x60,%dl
80102620:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102621:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102624:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010262a:	0f 84 88 00 00 00    	je     801026b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102630:	84 c0                	test   %al,%al
80102632:	79 2c                	jns    80102660 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102634:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010263a:	f6 c2 40             	test   $0x40,%dl
8010263d:	75 05                	jne    80102644 <kbdgetc+0x34>
8010263f:	89 c1                	mov    %eax,%ecx
80102641:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102644:	0f b6 81 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%eax
8010264b:	83 c8 40             	or     $0x40,%eax
8010264e:	0f b6 c0             	movzbl %al,%eax
80102651:	f7 d0                	not    %eax
80102653:	21 d0                	and    %edx,%eax
80102655:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010265a:	31 c0                	xor    %eax,%eax
8010265c:	c3                   	ret    
8010265d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010266a:	f6 c3 40             	test   $0x40,%bl
8010266d:	74 09                	je     80102678 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010266f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102672:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102675:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102678:	0f b6 91 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%edx
  shift ^= togglecode[data];
8010267f:	0f b6 81 40 75 10 80 	movzbl -0x7fef8ac0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102686:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102688:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010268a:	89 d0                	mov    %edx,%eax
8010268c:	83 e0 03             	and    $0x3,%eax
8010268f:	8b 04 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102696:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010269c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010269f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801026a3:	74 0b                	je     801026b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801026a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801026a8:	83 fa 19             	cmp    $0x19,%edx
801026ab:	77 1b                	ja     801026c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026b0:	5b                   	pop    %ebx
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	90                   	nop
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801026bf:	31 c0                	xor    %eax,%eax
801026c1:	c3                   	ret    
801026c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801026c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026cb:	8d 50 20             	lea    0x20(%eax),%edx
801026ce:	83 f9 19             	cmp    $0x19,%ecx
801026d1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801026d4:	eb da                	jmp    801026b0 <kbdgetc+0xa0>
801026d6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801026d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026dd:	c3                   	ret    
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801026e6:	c7 04 24 10 26 10 80 	movl   $0x80102610,(%esp)
801026ed:	e8 be e0 ff ff       	call   801007b0 <consoleintr>
}
801026f2:	c9                   	leave  
801026f3:	c3                   	ret    
801026f4:	66 90                	xchg   %ax,%ax
801026f6:	66 90                	xchg   %ax,%ax
801026f8:	66 90                	xchg   %ax,%ax
801026fa:	66 90                	xchg   %ax,%ax
801026fc:	66 90                	xchg   %ax,%ax
801026fe:	66 90                	xchg   %ax,%ax

80102700 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102700:	55                   	push   %ebp
80102701:	89 c1                	mov    %eax,%ecx
80102703:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102705:	ba 70 00 00 00       	mov    $0x70,%edx
8010270a:	53                   	push   %ebx
8010270b:	31 c0                	xor    %eax,%eax
8010270d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010270e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102713:	89 da                	mov    %ebx,%edx
80102715:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102716:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102719:	b2 70                	mov    $0x70,%dl
8010271b:	89 01                	mov    %eax,(%ecx)
8010271d:	b8 02 00 00 00       	mov    $0x2,%eax
80102722:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102723:	89 da                	mov    %ebx,%edx
80102725:	ec                   	in     (%dx),%al
80102726:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102729:	b2 70                	mov    $0x70,%dl
8010272b:	89 41 04             	mov    %eax,0x4(%ecx)
8010272e:	b8 04 00 00 00       	mov    $0x4,%eax
80102733:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102734:	89 da                	mov    %ebx,%edx
80102736:	ec                   	in     (%dx),%al
80102737:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010273a:	b2 70                	mov    $0x70,%dl
8010273c:	89 41 08             	mov    %eax,0x8(%ecx)
8010273f:	b8 07 00 00 00       	mov    $0x7,%eax
80102744:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102745:	89 da                	mov    %ebx,%edx
80102747:	ec                   	in     (%dx),%al
80102748:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010274b:	b2 70                	mov    $0x70,%dl
8010274d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102750:	b8 08 00 00 00       	mov    $0x8,%eax
80102755:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102756:	89 da                	mov    %ebx,%edx
80102758:	ec                   	in     (%dx),%al
80102759:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010275c:	b2 70                	mov    $0x70,%dl
8010275e:	89 41 10             	mov    %eax,0x10(%ecx)
80102761:	b8 09 00 00 00       	mov    $0x9,%eax
80102766:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102767:	89 da                	mov    %ebx,%edx
80102769:	ec                   	in     (%dx),%al
8010276a:	0f b6 d8             	movzbl %al,%ebx
8010276d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102770:	5b                   	pop    %ebx
80102771:	5d                   	pop    %ebp
80102772:	c3                   	ret    
80102773:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102780:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	0f 84 c0 00 00 00    	je     80102850 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102790:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102797:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027b4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027c1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ce:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027de:	8b 50 30             	mov    0x30(%eax),%edx
801027e1:	c1 ea 10             	shr    $0x10,%edx
801027e4:	80 fa 03             	cmp    $0x3,%dl
801027e7:	77 6f                	ja     80102858 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102800:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102803:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010280a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102810:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102817:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102831:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
80102837:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102838:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010283e:	80 e6 10             	and    $0x10,%dh
80102841:	75 f5                	jne    80102838 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102843:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010284a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102850:	5d                   	pop    %ebp
80102851:	c3                   	ret    
80102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102858:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010285f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102862:	8b 50 20             	mov    0x20(%eax),%edx
80102865:	eb 82                	jmp    801027e9 <lapicinit+0x69>
80102867:	89 f6                	mov    %esi,%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	56                   	push   %esi
80102874:	53                   	push   %ebx
80102875:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102878:	9c                   	pushf  
80102879:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010287a:	f6 c4 02             	test   $0x2,%ah
8010287d:	74 12                	je     80102891 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010287f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102884:	8d 50 01             	lea    0x1(%eax),%edx
80102887:	85 c0                	test   %eax,%eax
80102889:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010288f:	74 4a                	je     801028db <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102891:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102896:	85 c0                	test   %eax,%eax
80102898:	74 5d                	je     801028f7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010289a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010289d:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801028a3:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801028a6:	85 f6                	test   %esi,%esi
801028a8:	7e 56                	jle    80102900 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801028aa:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
801028b1:	39 d8                	cmp    %ebx,%eax
801028b3:	74 42                	je     801028f7 <cpunum+0x87>
801028b5:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801028ba:	31 c0                	xor    %eax,%eax
801028bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c0:	83 c0 01             	add    $0x1,%eax
801028c3:	39 f0                	cmp    %esi,%eax
801028c5:	74 39                	je     80102900 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801028c7:	0f b6 0a             	movzbl (%edx),%ecx
801028ca:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801028d0:	39 d9                	cmp    %ebx,%ecx
801028d2:	75 ec                	jne    801028c0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801028d4:	83 c4 10             	add    $0x10,%esp
801028d7:	5b                   	pop    %ebx
801028d8:	5e                   	pop    %esi
801028d9:	5d                   	pop    %ebp
801028da:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801028db:	8b 45 04             	mov    0x4(%ebp),%eax
801028de:	c7 04 24 40 77 10 80 	movl   $0x80107740,(%esp)
801028e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801028e9:	e8 62 dd ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801028ee:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801028f3:	85 c0                	test   %eax,%eax
801028f5:	75 a3                	jne    8010289a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801028f7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801028fa:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801028fc:	5b                   	pop    %ebx
801028fd:	5e                   	pop    %esi
801028fe:	5d                   	pop    %ebp
801028ff:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102900:	c7 04 24 6c 77 10 80 	movl   $0x8010776c,(%esp)
80102907:	e8 54 da ff ff       	call   80100360 <panic>
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102915:	55                   	push   %ebp
80102916:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102918:	85 c0                	test   %eax,%eax
8010291a:	74 0d                	je     80102929 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010291c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102923:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102926:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102929:	5d                   	pop    %ebp
8010292a:	c3                   	ret    
8010292b:	90                   	nop
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102930 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
}
80102933:	5d                   	pop    %ebp
80102934:	c3                   	ret    
80102935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	ba 70 00 00 00       	mov    $0x70,%edx
80102946:	89 e5                	mov    %esp,%ebp
80102948:	b8 0f 00 00 00       	mov    $0xf,%eax
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	b2 71                	mov    $0x71,%dl
8010295c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010295d:	31 c0                	xor    %eax,%eax
8010295f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102965:	89 d8                	mov    %ebx,%eax
80102967:	c1 e8 04             	shr    $0x4,%eax
8010296a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102970:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102975:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102978:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010297b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102981:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102984:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010298b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102991:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102998:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010299e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a4:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a7:	89 da                	mov    %ebx,%edx
801029a9:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ac:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b2:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029b5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bb:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029be:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801029c7:	5b                   	pop    %ebx
801029c8:	5d                   	pop    %ebp
801029c9:	c3                   	ret    
801029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	ba 70 00 00 00       	mov    $0x70,%edx
801029d6:	89 e5                	mov    %esp,%ebp
801029d8:	b8 0b 00 00 00       	mov    $0xb,%eax
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	b2 71                	mov    $0x71,%dl
801029e6:	ec                   	in     (%dx),%al
801029e7:	88 45 b7             	mov    %al,-0x49(%ebp)
801029ea:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ed:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801029f1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801029fd:	89 d8                	mov    %ebx,%eax
801029ff:	e8 fc fc ff ff       	call   80102700 <fill_rtcdate>
80102a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a09:	89 f2                	mov    %esi,%edx
80102a0b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	ba 71 00 00 00       	mov    $0x71,%edx
80102a11:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a12:	84 c0                	test   %al,%al
80102a14:	78 e7                	js     801029fd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102a16:	89 f8                	mov    %edi,%eax
80102a18:	e8 e3 fc ff ff       	call   80102700 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a1d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102a24:	00 
80102a25:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102a29:	89 1c 24             	mov    %ebx,(%esp)
80102a2c:	e8 6f 1a 00 00       	call   801044a0 <memcmp>
80102a31:	85 c0                	test   %eax,%eax
80102a33:	75 c3                	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a35:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102a39:	75 78                	jne    80102ab3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a3e:	89 c2                	mov    %eax,%edx
80102a40:	83 e0 0f             	and    $0xf,%eax
80102a43:	c1 ea 04             	shr    $0x4,%edx
80102a46:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a49:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a4f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a52:	89 c2                	mov    %eax,%edx
80102a54:	83 e0 0f             	and    $0xf,%eax
80102a57:	c1 ea 04             	shr    $0x4,%edx
80102a5a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a60:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a63:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a66:	89 c2                	mov    %eax,%edx
80102a68:	83 e0 0f             	and    $0xf,%eax
80102a6b:	c1 ea 04             	shr    $0x4,%edx
80102a6e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a71:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a74:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a7a:	89 c2                	mov    %eax,%edx
80102a7c:	83 e0 0f             	and    $0xf,%eax
80102a7f:	c1 ea 04             	shr    $0x4,%edx
80102a82:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a85:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a8e:	89 c2                	mov    %eax,%edx
80102a90:	83 e0 0f             	and    $0xf,%eax
80102a93:	c1 ea 04             	shr    $0x4,%edx
80102a96:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a99:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102aa2:	89 c2                	mov    %eax,%edx
80102aa4:	83 e0 0f             	and    $0xf,%eax
80102aa7:	c1 ea 04             	shr    $0x4,%edx
80102aaa:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aad:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102ab6:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ab9:	89 01                	mov    %eax,(%ecx)
80102abb:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102abe:	89 41 04             	mov    %eax,0x4(%ecx)
80102ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac4:	89 41 08             	mov    %eax,0x8(%ecx)
80102ac7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aca:	89 41 0c             	mov    %eax,0xc(%ecx)
80102acd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ad0:	89 41 10             	mov    %eax,0x10(%ecx)
80102ad3:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ad6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102ad9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102ae0:	83 c4 4c             	add    $0x4c,%esp
80102ae3:	5b                   	pop    %ebx
80102ae4:	5e                   	pop    %esi
80102ae5:	5f                   	pop    %edi
80102ae6:	5d                   	pop    %ebp
80102ae7:	c3                   	ret    
80102ae8:	66 90                	xchg   %ax,%ax
80102aea:	66 90                	xchg   %ax,%ax
80102aec:	66 90                	xchg   %ax,%ax
80102aee:	66 90                	xchg   %ax,%ax

80102af0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	57                   	push   %edi
80102af4:	56                   	push   %esi
80102af5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102af6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102af8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102afb:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102b00:	85 c0                	test   %eax,%eax
80102b02:	7e 78                	jle    80102b7c <install_trans+0x8c>
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b08:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102b0d:	01 d8                	add    %ebx,%eax
80102b0f:	83 c0 01             	add    $0x1,%eax
80102b12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b16:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b1b:	89 04 24             	mov    %eax,(%esp)
80102b1e:	e8 ad d5 ff ff       	call   801000d0 <bread>
80102b23:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b25:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b2c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b33:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b38:	89 04 24             	mov    %eax,(%esp)
80102b3b:	e8 90 d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102b47:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b48:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b4a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b51:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b54:	89 04 24             	mov    %eax,(%esp)
80102b57:	e8 94 19 00 00       	call   801044f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b5c:	89 34 24             	mov    %esi,(%esp)
80102b5f:	e8 3c d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b64:	89 3c 24             	mov    %edi,(%esp)
80102b67:	e8 74 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b6c:	89 34 24             	mov    %esi,(%esp)
80102b6f:	e8 6c d6 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b74:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102b7a:	7f 8c                	jg     80102b08 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102b7c:	83 c4 1c             	add    $0x1c,%esp
80102b7f:	5b                   	pop    %ebx
80102b80:	5e                   	pop    %esi
80102b81:	5f                   	pop    %edi
80102b82:	5d                   	pop    %ebp
80102b83:	c3                   	ret    
80102b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102b90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b99:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ba2:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102ba7:	89 04 24             	mov    %eax,(%esp)
80102baa:	e8 21 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102baf:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bb5:	31 d2                	xor    %edx,%edx
80102bb7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102bb9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102bbb:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102bbe:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102bc1:	7e 17                	jle    80102bda <write_head+0x4a>
80102bc3:	90                   	nop
80102bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102bc8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102bcf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bd3:	83 c2 01             	add    $0x1,%edx
80102bd6:	39 da                	cmp    %ebx,%edx
80102bd8:	75 ee                	jne    80102bc8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102bda:	89 3c 24             	mov    %edi,(%esp)
80102bdd:	e8 be d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102be2:	89 3c 24             	mov    %edi,(%esp)
80102be5:	e8 f6 d5 ff ff       	call   801001e0 <brelse>
}
80102bea:	83 c4 1c             	add    $0x1c,%esp
80102bed:	5b                   	pop    %ebx
80102bee:	5e                   	pop    %esi
80102bef:	5f                   	pop    %edi
80102bf0:	5d                   	pop    %ebp
80102bf1:	c3                   	ret    
80102bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	56                   	push   %esi
80102c04:	53                   	push   %ebx
80102c05:	83 ec 30             	sub    $0x30,%esp
80102c08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102c0b:	c7 44 24 04 7c 77 10 	movl   $0x8010777c,0x4(%esp)
80102c12:	80 
80102c13:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c1a:	e8 31 16 00 00       	call   80104250 <initlock>
  readsb(dev, &sb);
80102c1f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c26:	89 1c 24             	mov    %ebx,(%esp)
80102c29:	e8 62 e7 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102c31:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c34:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102c37:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c3d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102c41:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102c47:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c4c:	e8 7f d4 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102c51:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c53:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102c56:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102c59:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c5b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102c61:	7e 17                	jle    80102c7a <initlog+0x7a>
80102c63:	90                   	nop
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102c68:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102c6c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102c73:	83 c2 01             	add    $0x1,%edx
80102c76:	39 da                	cmp    %ebx,%edx
80102c78:	75 ee                	jne    80102c68 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102c7a:	89 04 24             	mov    %eax,(%esp)
80102c7d:	e8 5e d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c82:	e8 69 fe ff ff       	call   80102af0 <install_trans>
  log.lh.n = 0;
80102c87:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102c8e:	00 00 00 
  write_head(); // clear the log
80102c91:	e8 fa fe ff ff       	call   80102b90 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102c96:	83 c4 30             	add    $0x30,%esp
80102c99:	5b                   	pop    %ebx
80102c9a:	5e                   	pop    %esi
80102c9b:	5d                   	pop    %ebp
80102c9c:	c3                   	ret    
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ca0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102ca6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cad:	e8 1e 16 00 00       	call   801042d0 <acquire>
80102cb2:	eb 18                	jmp    80102ccc <begin_op+0x2c>
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cb8:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102cbf:	80 
80102cc0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cc7:	e8 24 11 00 00       	call   80103df0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102ccc:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102cd1:	85 c0                	test   %eax,%eax
80102cd3:	75 e3                	jne    80102cb8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cd5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102cda:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102ce0:	83 c0 01             	add    $0x1,%eax
80102ce3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ce6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102ce9:	83 fa 1e             	cmp    $0x1e,%edx
80102cec:	7f ca                	jg     80102cb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cee:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102cf5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102cfa:	e8 01 17 00 00       	call   80104400 <release>
      break;
    }
  }
}
80102cff:	c9                   	leave  
80102d00:	c3                   	ret    
80102d01:	eb 0d                	jmp    80102d10 <end_op>
80102d03:	90                   	nop
80102d04:	90                   	nop
80102d05:	90                   	nop
80102d06:	90                   	nop
80102d07:	90                   	nop
80102d08:	90                   	nop
80102d09:	90                   	nop
80102d0a:	90                   	nop
80102d0b:	90                   	nop
80102d0c:	90                   	nop
80102d0d:	90                   	nop
80102d0e:	90                   	nop
80102d0f:	90                   	nop

80102d10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	57                   	push   %edi
80102d14:	56                   	push   %esi
80102d15:	53                   	push   %ebx
80102d16:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d19:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d20:	e8 ab 15 00 00       	call   801042d0 <acquire>
  log.outstanding -= 1;
80102d25:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102d2a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d30:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102d33:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d35:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102d3a:	0f 85 f3 00 00 00    	jne    80102e33 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102d40:	85 c0                	test   %eax,%eax
80102d42:	0f 85 cb 00 00 00    	jne    80102e13 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d48:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d4f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102d51:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102d58:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d5b:	e8 a0 16 00 00       	call   80104400 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d60:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d65:	85 c0                	test   %eax,%eax
80102d67:	0f 8e 90 00 00 00    	jle    80102dfd <end_op+0xed>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102d75:	01 d8                	add    %ebx,%eax
80102d77:	83 c0 01             	add    $0x1,%eax
80102d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d7e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102d83:	89 04 24             	mov    %eax,(%esp)
80102d86:	e8 45 d3 ff ff       	call   801000d0 <bread>
80102d8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d8d:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d94:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d97:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d9b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102da0:	89 04 24             	mov    %eax,(%esp)
80102da3:	e8 28 d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102da8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102daf:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102db0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102db2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102db5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dbc:	89 04 24             	mov    %eax,(%esp)
80102dbf:	e8 2c 17 00 00       	call   801044f0 <memmove>
    bwrite(to);  // write the log
80102dc4:	89 34 24             	mov    %esi,(%esp)
80102dc7:	e8 d4 d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102dcc:	89 3c 24             	mov    %edi,(%esp)
80102dcf:	e8 0c d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102dd4:	89 34 24             	mov    %esi,(%esp)
80102dd7:	e8 04 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ddc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102de2:	7c 8c                	jl     80102d70 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102de4:	e8 a7 fd ff ff       	call   80102b90 <write_head>
    install_trans(); // Now install writes to home locations
80102de9:	e8 02 fd ff ff       	call   80102af0 <install_trans>
    log.lh.n = 0;
80102dee:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102df5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102df8:	e8 93 fd ff ff       	call   80102b90 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102dfd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e04:	e8 c7 14 00 00       	call   801042d0 <acquire>
    log.committing = 0;
80102e09:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e10:	00 00 00 
    wakeup(&log);
80102e13:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e1a:	e8 71 11 00 00       	call   80103f90 <wakeup>
    release(&log.lock);
80102e1f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e26:	e8 d5 15 00 00       	call   80104400 <release>
  }
}
80102e2b:	83 c4 1c             	add    $0x1c,%esp
80102e2e:	5b                   	pop    %ebx
80102e2f:	5e                   	pop    %esi
80102e30:	5f                   	pop    %edi
80102e31:	5d                   	pop    %ebp
80102e32:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102e33:	c7 04 24 80 77 10 80 	movl   $0x80107780,(%esp)
80102e3a:	e8 21 d5 ff ff       	call   80100360 <panic>
80102e3f:	90                   	nop

80102e40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e47:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e4f:	83 f8 1d             	cmp    $0x1d,%eax
80102e52:	0f 8f 98 00 00 00    	jg     80102ef0 <log_write+0xb0>
80102e58:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102e5e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102e61:	39 d0                	cmp    %edx,%eax
80102e63:	0f 8d 87 00 00 00    	jge    80102ef0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e69:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e6e:	85 c0                	test   %eax,%eax
80102e70:	0f 8e 86 00 00 00    	jle    80102efc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e76:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e7d:	e8 4e 14 00 00       	call   801042d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e82:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e88:	83 fa 00             	cmp    $0x0,%edx
80102e8b:	7e 54                	jle    80102ee1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e8d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e90:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e92:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102e98:	75 0f                	jne    80102ea9 <log_write+0x69>
80102e9a:	eb 3c                	jmp    80102ed8 <log_write+0x98>
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ea0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102ea7:	74 2f                	je     80102ed8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ea9:	83 c0 01             	add    $0x1,%eax
80102eac:	39 d0                	cmp    %edx,%eax
80102eae:	75 f0                	jne    80102ea0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102eb0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102eb7:	83 c2 01             	add    $0x1,%edx
80102eba:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102ec0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ec3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102eca:	83 c4 14             	add    $0x14,%esp
80102ecd:	5b                   	pop    %ebx
80102ece:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102ecf:	e9 2c 15 00 00       	jmp    80104400 <release>
80102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ed8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102edf:	eb df                	jmp    80102ec0 <log_write+0x80>
80102ee1:	8b 43 08             	mov    0x8(%ebx),%eax
80102ee4:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102ee9:	75 d5                	jne    80102ec0 <log_write+0x80>
80102eeb:	eb ca                	jmp    80102eb7 <log_write+0x77>
80102eed:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102ef0:	c7 04 24 8f 77 10 80 	movl   $0x8010778f,(%esp)
80102ef7:	e8 64 d4 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102efc:	c7 04 24 a5 77 10 80 	movl   $0x801077a5,(%esp)
80102f03:	e8 58 d4 ff ff       	call   80100360 <panic>
80102f08:	66 90                	xchg   %ax,%ax
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102f16:	e8 55 f9 ff ff       	call   80102870 <cpunum>
80102f1b:	c7 04 24 c0 77 10 80 	movl   $0x801077c0,(%esp)
80102f22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f26:	e8 25 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102f2b:	e8 b0 2b 00 00       	call   80105ae0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102f30:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f37:	b8 01 00 00 00       	mov    $0x1,%eax
80102f3c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102f43:	e8 f8 0b 00 00       	call   80103b40 <scheduler>
80102f48:	90                   	nop
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f56:	e8 75 3d 00 00       	call   80106cd0 <switchkvm>
  seginit();
80102f5b:	e8 90 3b 00 00       	call   80106af0 <seginit>
  lapicinit();
80102f60:	e8 1b f8 ff ff       	call   80102780 <lapicinit>
  mpmain();
80102f65:	e8 a6 ff ff ff       	call   80102f10 <mpmain>
80102f6a:	66 90                	xchg   %ax,%ax
80102f6c:	66 90                	xchg   %ax,%ax
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 e4 f0             	and    $0xfffffff0,%esp
80102f77:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f7a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102f81:	80 
80102f82:	c7 04 24 88 55 11 80 	movl   $0x80115588,(%esp)
80102f89:	e8 62 f5 ff ff       	call   801024f0 <kinit1>
  kvmalloc();      // kernel page table
80102f8e:	e8 1d 3d 00 00       	call   80106cb0 <kvmalloc>
  mpinit();        // detect other processors
80102f93:	e8 a8 01 00 00       	call   80103140 <mpinit>
  lapicinit();     // interrupt controller
80102f98:	e8 e3 f7 ff ff       	call   80102780 <lapicinit>
80102f9d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102fa0:	e8 4b 3b 00 00       	call   80106af0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102fa5:	e8 c6 f8 ff ff       	call   80102870 <cpunum>
80102faa:	c7 04 24 d1 77 10 80 	movl   $0x801077d1,(%esp)
80102fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fb5:	e8 96 d6 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102fba:	e8 81 03 00 00       	call   80103340 <picinit>
  ioapicinit();    // another interrupt controller
80102fbf:	e8 4c f3 ff ff       	call   80102310 <ioapicinit>
  consoleinit();   // console hardware
80102fc4:	e8 87 d9 ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102fc9:	e8 32 2e 00 00       	call   80105e00 <uartinit>
80102fce:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102fd0:	e8 9b 08 00 00       	call   80103870 <pinit>
  tvinit();        // trap vectors
80102fd5:	e8 66 2a 00 00       	call   80105a40 <tvinit>
  binit();         // buffer cache
80102fda:	e8 61 d0 ff ff       	call   80100040 <binit>
80102fdf:	90                   	nop
  fileinit();      // file table
80102fe0:	e8 5b dd ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk
80102fe5:	e8 16 f1 ff ff       	call   80102100 <ideinit>
  if(!ismp)
80102fea:	a1 84 27 11 80       	mov    0x80112784,%eax
80102fef:	85 c0                	test   %eax,%eax
80102ff1:	0f 84 ca 00 00 00    	je     801030c1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ff7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ffe:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102fff:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103004:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
8010300b:	80 
8010300c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80103013:	e8 d8 14 00 00       	call   801044f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103018:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
8010301f:	00 00 00 
80103022:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103027:	39 d8                	cmp    %ebx,%eax
80103029:	76 78                	jbe    801030a3 <main+0x133>
8010302b:	90                   	nop
8010302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80103030:	e8 3b f8 ff ff       	call   80102870 <cpunum>
80103035:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010303b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103040:	39 c3                	cmp    %eax,%ebx
80103042:	74 46                	je     8010308a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103044:	e8 67 f5 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80103049:	c7 05 f8 6f 00 80 50 	movl   $0x80102f50,0x80006ff8
80103050:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103053:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010305a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010305d:	05 00 10 00 00       	add    $0x1000,%eax
80103062:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103067:	0f b6 03             	movzbl (%ebx),%eax
8010306a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80103071:	00 
80103072:	89 04 24             	mov    %eax,(%esp)
80103075:	e8 c6 f8 ff ff       	call   80102940 <lapicstartap>
8010307a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103080:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103086:	85 c0                	test   %eax,%eax
80103088:	74 f6                	je     80103080 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010308a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80103091:	00 00 00 
80103094:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010309a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010309f:	39 c3                	cmp    %eax,%ebx
801030a1:	72 8d                	jb     80103030 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030a3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801030aa:	8e 
801030ab:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801030b2:	e8 a9 f4 ff ff       	call   80102560 <kinit2>
  userinit();      // first user process
801030b7:	e8 d4 07 00 00       	call   80103890 <userinit>
  mpmain();        // finish this processor's setup
801030bc:	e8 4f fe ff ff       	call   80102f10 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
801030c1:	e8 1a 29 00 00       	call   801059e0 <timerinit>
801030c6:	e9 2c ff ff ff       	jmp    80102ff7 <main+0x87>
801030cb:	66 90                	xchg   %ax,%ax
801030cd:	66 90                	xchg   %ax,%ax
801030cf:	90                   	nop

801030d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030d4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030da:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801030db:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030de:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030e1:	39 de                	cmp    %ebx,%esi
801030e3:	73 3c                	jae    80103121 <mpsearch1+0x51>
801030e5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030e8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030ef:	00 
801030f0:	c7 44 24 04 e8 77 10 	movl   $0x801077e8,0x4(%esp)
801030f7:	80 
801030f8:	89 34 24             	mov    %esi,(%esp)
801030fb:	e8 a0 13 00 00       	call   801044a0 <memcmp>
80103100:	85 c0                	test   %eax,%eax
80103102:	75 16                	jne    8010311a <mpsearch1+0x4a>
80103104:	31 c9                	xor    %ecx,%ecx
80103106:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103108:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010310c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010310f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103111:	83 fa 10             	cmp    $0x10,%edx
80103114:	75 f2                	jne    80103108 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103116:	84 c9                	test   %cl,%cl
80103118:	74 10                	je     8010312a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010311a:	83 c6 10             	add    $0x10,%esi
8010311d:	39 f3                	cmp    %esi,%ebx
8010311f:	77 c7                	ja     801030e8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103121:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103124:	31 c0                	xor    %eax,%eax
}
80103126:	5b                   	pop    %ebx
80103127:	5e                   	pop    %esi
80103128:	5d                   	pop    %ebp
80103129:	c3                   	ret    
8010312a:	83 c4 10             	add    $0x10,%esp
8010312d:	89 f0                	mov    %esi,%eax
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5d                   	pop    %ebp
80103132:	c3                   	ret    
80103133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103140 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	57                   	push   %edi
80103144:	56                   	push   %esi
80103145:	53                   	push   %ebx
80103146:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103149:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103150:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103157:	c1 e0 08             	shl    $0x8,%eax
8010315a:	09 d0                	or     %edx,%eax
8010315c:	c1 e0 04             	shl    $0x4,%eax
8010315f:	85 c0                	test   %eax,%eax
80103161:	75 1b                	jne    8010317e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103163:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010316a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103171:	c1 e0 08             	shl    $0x8,%eax
80103174:	09 d0                	or     %edx,%eax
80103176:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103179:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010317e:	ba 00 04 00 00       	mov    $0x400,%edx
80103183:	e8 48 ff ff ff       	call   801030d0 <mpsearch1>
80103188:	85 c0                	test   %eax,%eax
8010318a:	89 c7                	mov    %eax,%edi
8010318c:	0f 84 4e 01 00 00    	je     801032e0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103192:	8b 77 04             	mov    0x4(%edi),%esi
80103195:	85 f6                	test   %esi,%esi
80103197:	0f 84 ce 00 00 00    	je     8010326b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010319d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031a3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801031aa:	00 
801031ab:	c7 44 24 04 ed 77 10 	movl   $0x801077ed,0x4(%esp)
801031b2:	80 
801031b3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031b9:	e8 e2 12 00 00       	call   801044a0 <memcmp>
801031be:	85 c0                	test   %eax,%eax
801031c0:	0f 85 a5 00 00 00    	jne    8010326b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031c6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801031cd:	3c 04                	cmp    $0x4,%al
801031cf:	0f 85 29 01 00 00    	jne    801032fe <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031d5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031dc:	85 c0                	test   %eax,%eax
801031de:	74 1d                	je     801031fd <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801031e0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801031e2:	31 d2                	xor    %edx,%edx
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801031e8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801031ef:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031f0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031f3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031f5:	39 d0                	cmp    %edx,%eax
801031f7:	7f ef                	jg     801031e8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031f9:	84 c9                	test   %cl,%cl
801031fb:	75 6e                	jne    8010326b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103200:	85 db                	test   %ebx,%ebx
80103202:	74 67                	je     8010326b <mpinit+0x12b>
    return;
  ismp = 1;
80103204:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010320b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010320e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103214:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103219:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103220:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103226:	01 d9                	add    %ebx,%ecx
80103228:	39 c8                	cmp    %ecx,%eax
8010322a:	0f 83 90 00 00 00    	jae    801032c0 <mpinit+0x180>
    switch(*p){
80103230:	80 38 04             	cmpb   $0x4,(%eax)
80103233:	77 7b                	ja     801032b0 <mpinit+0x170>
80103235:	0f b6 10             	movzbl (%eax),%edx
80103238:	ff 24 95 f4 77 10 80 	jmp    *-0x7fef880c(,%edx,4)
8010323f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103240:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103243:	39 c1                	cmp    %eax,%ecx
80103245:	77 e9                	ja     80103230 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103247:	a1 84 27 11 80       	mov    0x80112784,%eax
8010324c:	85 c0                	test   %eax,%eax
8010324e:	75 70                	jne    801032c0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103250:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103257:	00 00 00 
    lapic = 0;
8010325a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103261:	00 00 00 
    ioapicid = 0;
80103264:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010326b:	83 c4 1c             	add    $0x1c,%esp
8010326e:	5b                   	pop    %ebx
8010326f:	5e                   	pop    %esi
80103270:	5f                   	pop    %edi
80103271:	5d                   	pop    %ebp
80103272:	c3                   	ret    
80103273:	90                   	nop
80103274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103278:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010327e:	83 fa 07             	cmp    $0x7,%edx
80103281:	7f 17                	jg     8010329a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103283:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103287:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010328d:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103294:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010329a:	83 c0 14             	add    $0x14,%eax
      continue;
8010329d:	eb a4                	jmp    80103243 <mpinit+0x103>
8010329f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032a4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032a7:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801032ad:	eb 94                	jmp    80103243 <mpinit+0x103>
801032af:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801032b0:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801032b7:	00 00 00 
      break;
801032ba:	eb 87                	jmp    80103243 <mpinit+0x103>
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801032c0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032c4:	74 a5                	je     8010326b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c6:	ba 22 00 00 00       	mov    $0x22,%edx
801032cb:	b8 70 00 00 00       	mov    $0x70,%eax
801032d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d1:	b2 23                	mov    $0x23,%dl
801032d3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032d4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d7:	ee                   	out    %al,(%dx)
  }
}
801032d8:	83 c4 1c             	add    $0x1c,%esp
801032db:	5b                   	pop    %ebx
801032dc:	5e                   	pop    %esi
801032dd:	5f                   	pop    %edi
801032de:	5d                   	pop    %ebp
801032df:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032ea:	e8 e1 fd ff ff       	call   801030d0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032ef:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032f1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f3:	0f 85 99 fe ff ff    	jne    80103192 <mpinit+0x52>
801032f9:	e9 6d ff ff ff       	jmp    8010326b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801032fe:	3c 01                	cmp    $0x1,%al
80103300:	0f 84 cf fe ff ff    	je     801031d5 <mpinit+0x95>
80103306:	e9 60 ff ff ff       	jmp    8010326b <mpinit+0x12b>
8010330b:	66 90                	xchg   %ax,%ax
8010330d:	66 90                	xchg   %ax,%ax
8010330f:	90                   	nop

80103310 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103310:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103311:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103316:	89 e5                	mov    %esp,%ebp
80103318:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010331d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103320:	d3 c0                	rol    %cl,%eax
80103322:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103329:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010332f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103330:	66 c1 e8 08          	shr    $0x8,%ax
80103334:	b2 a1                	mov    $0xa1,%dl
80103336:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103337:	5d                   	pop    %ebp
80103338:	c3                   	ret    
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103340 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103340:	55                   	push   %ebp
80103341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103346:	89 e5                	mov    %esp,%ebp
80103348:	57                   	push   %edi
80103349:	56                   	push   %esi
8010334a:	53                   	push   %ebx
8010334b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103350:	89 da                	mov    %ebx,%edx
80103352:	ee                   	out    %al,(%dx)
80103353:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103358:	89 ca                	mov    %ecx,%edx
8010335a:	ee                   	out    %al,(%dx)
8010335b:	bf 11 00 00 00       	mov    $0x11,%edi
80103360:	be 20 00 00 00       	mov    $0x20,%esi
80103365:	89 f8                	mov    %edi,%eax
80103367:	89 f2                	mov    %esi,%edx
80103369:	ee                   	out    %al,(%dx)
8010336a:	b8 20 00 00 00       	mov    $0x20,%eax
8010336f:	89 da                	mov    %ebx,%edx
80103371:	ee                   	out    %al,(%dx)
80103372:	b8 04 00 00 00       	mov    $0x4,%eax
80103377:	ee                   	out    %al,(%dx)
80103378:	b8 03 00 00 00       	mov    $0x3,%eax
8010337d:	ee                   	out    %al,(%dx)
8010337e:	b3 a0                	mov    $0xa0,%bl
80103380:	89 f8                	mov    %edi,%eax
80103382:	89 da                	mov    %ebx,%edx
80103384:	ee                   	out    %al,(%dx)
80103385:	b8 28 00 00 00       	mov    $0x28,%eax
8010338a:	89 ca                	mov    %ecx,%edx
8010338c:	ee                   	out    %al,(%dx)
8010338d:	b8 02 00 00 00       	mov    $0x2,%eax
80103392:	ee                   	out    %al,(%dx)
80103393:	b8 03 00 00 00       	mov    $0x3,%eax
80103398:	ee                   	out    %al,(%dx)
80103399:	bf 68 00 00 00       	mov    $0x68,%edi
8010339e:	89 f2                	mov    %esi,%edx
801033a0:	89 f8                	mov    %edi,%eax
801033a2:	ee                   	out    %al,(%dx)
801033a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
801033a8:	89 c8                	mov    %ecx,%eax
801033aa:	ee                   	out    %al,(%dx)
801033ab:	89 f8                	mov    %edi,%eax
801033ad:	89 da                	mov    %ebx,%edx
801033af:	ee                   	out    %al,(%dx)
801033b0:	89 c8                	mov    %ecx,%eax
801033b2:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801033b3:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801033ba:	66 83 f8 ff          	cmp    $0xffff,%ax
801033be:	74 0a                	je     801033ca <picinit+0x8a>
801033c0:	b2 21                	mov    $0x21,%dl
801033c2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801033c3:	66 c1 e8 08          	shr    $0x8,%ax
801033c7:	b2 a1                	mov    $0xa1,%dl
801033c9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801033ca:	5b                   	pop    %ebx
801033cb:	5e                   	pop    %esi
801033cc:	5f                   	pop    %edi
801033cd:	5d                   	pop    %ebp
801033ce:	c3                   	ret    
801033cf:	90                   	nop

801033d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
801033dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801033e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033eb:	e8 70 d9 ff ff       	call   80100d60 <filealloc>
801033f0:	85 c0                	test   %eax,%eax
801033f2:	89 06                	mov    %eax,(%esi)
801033f4:	0f 84 a4 00 00 00    	je     8010349e <pipealloc+0xce>
801033fa:	e8 61 d9 ff ff       	call   80100d60 <filealloc>
801033ff:	85 c0                	test   %eax,%eax
80103401:	89 03                	mov    %eax,(%ebx)
80103403:	0f 84 87 00 00 00    	je     80103490 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103409:	e8 a2 f1 ff ff       	call   801025b0 <kalloc>
8010340e:	85 c0                	test   %eax,%eax
80103410:	89 c7                	mov    %eax,%edi
80103412:	74 7c                	je     80103490 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103414:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010341b:	00 00 00 
  p->writeopen = 1;
8010341e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103425:	00 00 00 
  p->nwrite = 0;
80103428:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010342f:	00 00 00 
  p->nread = 0;
80103432:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103439:	00 00 00 
  initlock(&p->lock, "pipe");
8010343c:	89 04 24             	mov    %eax,(%esp)
8010343f:	c7 44 24 04 08 78 10 	movl   $0x80107808,0x4(%esp)
80103446:	80 
80103447:	e8 04 0e 00 00       	call   80104250 <initlock>
  (*f0)->type = FD_PIPE;
8010344c:	8b 06                	mov    (%esi),%eax
8010344e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103454:	8b 06                	mov    (%esi),%eax
80103456:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010345a:	8b 06                	mov    (%esi),%eax
8010345c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103460:	8b 06                	mov    (%esi),%eax
80103462:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103465:	8b 03                	mov    (%ebx),%eax
80103467:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010346d:	8b 03                	mov    (%ebx),%eax
8010346f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103473:	8b 03                	mov    (%ebx),%eax
80103475:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103479:	8b 03                	mov    (%ebx),%eax
  return 0;
8010347b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010347d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103480:	83 c4 1c             	add    $0x1c,%esp
80103483:	89 d8                	mov    %ebx,%eax
80103485:	5b                   	pop    %ebx
80103486:	5e                   	pop    %esi
80103487:	5f                   	pop    %edi
80103488:	5d                   	pop    %ebp
80103489:	c3                   	ret    
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103490:	8b 06                	mov    (%esi),%eax
80103492:	85 c0                	test   %eax,%eax
80103494:	74 08                	je     8010349e <pipealloc+0xce>
    fileclose(*f0);
80103496:	89 04 24             	mov    %eax,(%esp)
80103499:	e8 82 d9 ff ff       	call   80100e20 <fileclose>
  if(*f1)
8010349e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801034a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801034a5:	85 c0                	test   %eax,%eax
801034a7:	74 d7                	je     80103480 <pipealloc+0xb0>
    fileclose(*f1);
801034a9:	89 04 24             	mov    %eax,(%esp)
801034ac:	e8 6f d9 ff ff       	call   80100e20 <fileclose>
  return -1;
}
801034b1:	83 c4 1c             	add    $0x1c,%esp
801034b4:	89 d8                	mov    %ebx,%eax
801034b6:	5b                   	pop    %ebx
801034b7:	5e                   	pop    %esi
801034b8:	5f                   	pop    %edi
801034b9:	5d                   	pop    %ebp
801034ba:	c3                   	ret    
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	56                   	push   %esi
801034c4:	53                   	push   %ebx
801034c5:	83 ec 10             	sub    $0x10,%esp
801034c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034ce:	89 1c 24             	mov    %ebx,(%esp)
801034d1:	e8 fa 0d 00 00       	call   801042d0 <acquire>
  if(writable){
801034d6:	85 f6                	test   %esi,%esi
801034d8:	74 3e                	je     80103518 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801034da:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801034e0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034e7:	00 00 00 
    wakeup(&p->nread);
801034ea:	89 04 24             	mov    %eax,(%esp)
801034ed:	e8 9e 0a 00 00       	call   80103f90 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034f2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034f8:	85 d2                	test   %edx,%edx
801034fa:	75 0a                	jne    80103506 <pipeclose+0x46>
801034fc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 32                	je     80103538 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103506:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	5b                   	pop    %ebx
8010350d:	5e                   	pop    %esi
8010350e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010350f:	e9 ec 0e 00 00       	jmp    80104400 <release>
80103514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103518:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010351e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103525:	00 00 00 
    wakeup(&p->nwrite);
80103528:	89 04 24             	mov    %eax,(%esp)
8010352b:	e8 60 0a 00 00       	call   80103f90 <wakeup>
80103530:	eb c0                	jmp    801034f2 <pipeclose+0x32>
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103538:	89 1c 24             	mov    %ebx,(%esp)
8010353b:	e8 c0 0e 00 00       	call   80104400 <release>
    kfree((char*)p);
80103540:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103543:	83 c4 10             	add    $0x10,%esp
80103546:	5b                   	pop    %ebx
80103547:	5e                   	pop    %esi
80103548:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103549:	e9 b2 ee ff ff       	jmp    80102400 <kfree>
8010354e:	66 90                	xchg   %ax,%ax

80103550 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
80103559:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010355c:	89 3c 24             	mov    %edi,(%esp)
8010355f:	e8 6c 0d 00 00       	call   801042d0 <acquire>
  for(i = 0; i < n; i++){
80103564:	8b 45 10             	mov    0x10(%ebp),%eax
80103567:	85 c0                	test   %eax,%eax
80103569:	0f 8e c2 00 00 00    	jle    80103631 <pipewrite+0xe1>
8010356f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103572:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103578:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010357e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103587:	03 45 10             	add    0x10(%ebp),%eax
8010358a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010358d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103593:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103599:	39 d1                	cmp    %edx,%ecx
8010359b:	0f 85 c4 00 00 00    	jne    80103665 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
801035a1:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801035a7:	85 d2                	test   %edx,%edx
801035a9:	0f 84 a1 00 00 00    	je     80103650 <pipewrite+0x100>
801035af:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801035b6:	8b 42 24             	mov    0x24(%edx),%eax
801035b9:	85 c0                	test   %eax,%eax
801035bb:	74 22                	je     801035df <pipewrite+0x8f>
801035bd:	e9 8e 00 00 00       	jmp    80103650 <pipewrite+0x100>
801035c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035c8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801035ce:	85 c0                	test   %eax,%eax
801035d0:	74 7e                	je     80103650 <pipewrite+0x100>
801035d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035d8:	8b 48 24             	mov    0x24(%eax),%ecx
801035db:	85 c9                	test   %ecx,%ecx
801035dd:	75 71                	jne    80103650 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035df:	89 34 24             	mov    %esi,(%esp)
801035e2:	e8 a9 09 00 00       	call   80103f90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801035eb:	89 1c 24             	mov    %ebx,(%esp)
801035ee:	e8 fd 07 00 00       	call   80103df0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035f9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035ff:	05 00 02 00 00       	add    $0x200,%eax
80103604:	39 c2                	cmp    %eax,%edx
80103606:	74 c0                	je     801035c8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010360b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010360e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103614:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010361a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010361e:	0f b6 00             	movzbl (%eax),%eax
80103621:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103628:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010362b:	0f 85 5c ff ff ff    	jne    8010358d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103631:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103637:	89 14 24             	mov    %edx,(%esp)
8010363a:	e8 51 09 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
8010363f:	89 3c 24             	mov    %edi,(%esp)
80103642:	e8 b9 0d 00 00       	call   80104400 <release>
  return n;
80103647:	8b 45 10             	mov    0x10(%ebp),%eax
8010364a:	eb 11                	jmp    8010365d <pipewrite+0x10d>
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103650:	89 3c 24             	mov    %edi,(%esp)
80103653:	e8 a8 0d 00 00       	call   80104400 <release>
        return -1;
80103658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010365d:	83 c4 1c             	add    $0x1c,%esp
80103660:	5b                   	pop    %ebx
80103661:	5e                   	pop    %esi
80103662:	5f                   	pop    %edi
80103663:	5d                   	pop    %ebp
80103664:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103665:	89 ca                	mov    %ecx,%edx
80103667:	eb 9f                	jmp    80103608 <pipewrite+0xb8>
80103669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103670 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	57                   	push   %edi
80103674:	56                   	push   %esi
80103675:	53                   	push   %ebx
80103676:	83 ec 1c             	sub    $0x1c,%esp
80103679:	8b 75 08             	mov    0x8(%ebp),%esi
8010367c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010367f:	89 34 24             	mov    %esi,(%esp)
80103682:	e8 49 0c 00 00       	call   801042d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103687:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010368d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103693:	75 5b                	jne    801036f0 <piperead+0x80>
80103695:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010369b:	85 db                	test   %ebx,%ebx
8010369d:	74 51                	je     801036f0 <piperead+0x80>
8010369f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036a5:	eb 25                	jmp    801036cc <piperead+0x5c>
801036a7:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036a8:	89 74 24 04          	mov    %esi,0x4(%esp)
801036ac:	89 1c 24             	mov    %ebx,(%esp)
801036af:	e8 3c 07 00 00       	call   80103df0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036b4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036ba:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036c0:	75 2e                	jne    801036f0 <piperead+0x80>
801036c2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036c8:	85 d2                	test   %edx,%edx
801036ca:	74 24                	je     801036f0 <piperead+0x80>
    if(proc->killed){
801036cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801036d2:	8b 48 24             	mov    0x24(%eax),%ecx
801036d5:	85 c9                	test   %ecx,%ecx
801036d7:	74 cf                	je     801036a8 <piperead+0x38>
      release(&p->lock);
801036d9:	89 34 24             	mov    %esi,(%esp)
801036dc:	e8 1f 0d 00 00       	call   80104400 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036e1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036e9:	5b                   	pop    %ebx
801036ea:	5e                   	pop    %esi
801036eb:	5f                   	pop    %edi
801036ec:	5d                   	pop    %ebp
801036ed:	c3                   	ret    
801036ee:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036f0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801036f3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036f5:	85 d2                	test   %edx,%edx
801036f7:	7f 2b                	jg     80103724 <piperead+0xb4>
801036f9:	eb 31                	jmp    8010372c <piperead+0xbc>
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103700:	8d 48 01             	lea    0x1(%eax),%ecx
80103703:	25 ff 01 00 00       	and    $0x1ff,%eax
80103708:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010370e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103713:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103716:	83 c3 01             	add    $0x1,%ebx
80103719:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010371c:	74 0e                	je     8010372c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010371e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103724:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010372a:	75 d4                	jne    80103700 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010372c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103732:	89 04 24             	mov    %eax,(%esp)
80103735:	e8 56 08 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
8010373a:	89 34 24             	mov    %esi,(%esp)
8010373d:	e8 be 0c 00 00       	call   80104400 <release>
  return i;
}
80103742:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103745:	89 d8                	mov    %ebx,%eax
}
80103747:	5b                   	pop    %ebx
80103748:	5e                   	pop    %esi
80103749:	5f                   	pop    %edi
8010374a:	5d                   	pop    %ebp
8010374b:	c3                   	ret    
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103754:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103759:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010375c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103763:	e8 68 0b 00 00       	call   801042d0 <acquire>
80103768:	eb 11                	jmp    8010377b <allocproc+0x2b>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103770:	83 c3 7c             	add    $0x7c,%ebx
80103773:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103779:	74 7d                	je     801037f8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010377b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010377e:	85 c0                	test   %eax,%eax
80103780:	75 ee                	jne    80103770 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103782:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
80103787:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010378e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103795:	8d 50 01             	lea    0x1(%eax),%edx
80103798:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
8010379e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
801037a1:	e8 5a 0c 00 00       	call   80104400 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037a6:	e8 05 ee ff ff       	call   801025b0 <kalloc>
801037ab:	85 c0                	test   %eax,%eax
801037ad:	89 43 08             	mov    %eax,0x8(%ebx)
801037b0:	74 5a                	je     8010380c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037b2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801037b8:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037bd:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037c0:	c7 40 14 2d 5a 10 80 	movl   $0x80105a2d,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037c7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801037ce:	00 
801037cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037d6:	00 
801037d7:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037da:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037dd:	e8 6e 0c 00 00       	call   80104450 <memset>
  p->context->eip = (uint)forkret;
801037e2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037e5:	c7 40 10 20 38 10 80 	movl   $0x80103820,0x10(%eax)

  return p;
801037ec:	89 d8                	mov    %ebx,%eax
}
801037ee:	83 c4 14             	add    $0x14,%esp
801037f1:	5b                   	pop    %ebx
801037f2:	5d                   	pop    %ebp
801037f3:	c3                   	ret    
801037f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801037f8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801037ff:	e8 fc 0b 00 00       	call   80104400 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103804:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103807:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103809:	5b                   	pop    %ebx
8010380a:	5d                   	pop    %ebp
8010380b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010380c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103813:	eb d9                	jmp    801037ee <allocproc+0x9e>
80103815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103826:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010382d:	e8 ce 0b 00 00       	call   80104400 <release>

  if (first) {
80103832:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103837:	85 c0                	test   %eax,%eax
80103839:	75 05                	jne    80103840 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010383b:	c9                   	leave  
8010383c:	c3                   	ret    
8010383d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103840:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103847:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010384e:	00 00 00 
    iinit(ROOTDEV);
80103851:	e8 1a dc ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103856:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010385d:	e8 9e f3 ff ff       	call   80102c00 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103862:	c9                   	leave  
80103863:	c3                   	ret    
80103864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010386a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103870 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103876:	c7 44 24 04 0d 78 10 	movl   $0x8010780d,0x4(%esp)
8010387d:	80 
8010387e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103885:	e8 c6 09 00 00       	call   80104250 <initlock>
}
8010388a:	c9                   	leave  
8010388b:	c3                   	ret    
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103897:	e8 b4 fe ff ff       	call   80103750 <allocproc>
8010389c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010389e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801038a3:	e8 88 33 00 00       	call   80106c30 <setupkvm>
801038a8:	85 c0                	test   %eax,%eax
801038aa:	89 43 04             	mov    %eax,0x4(%ebx)
801038ad:	0f 84 d4 00 00 00    	je     80103987 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038b3:	89 04 24             	mov    %eax,(%esp)
801038b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801038bd:	00 
801038be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801038c5:	80 
801038c6:	e8 f5 34 00 00       	call   80106dc0 <inituvm>
  p->sz = PGSIZE;
801038cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801038d8:	00 
801038d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801038e0:	00 
801038e1:	8b 43 18             	mov    0x18(%ebx),%eax
801038e4:	89 04 24             	mov    %eax,(%esp)
801038e7:	e8 64 0b 00 00       	call   80104450 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038ec:	8b 43 18             	mov    0x18(%ebx),%eax
801038ef:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038f4:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038f9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038fd:	8b 43 18             	mov    0x18(%ebx),%eax
80103900:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103904:	8b 43 18             	mov    0x18(%ebx),%eax
80103907:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010390b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010390f:	8b 43 18             	mov    0x18(%ebx),%eax
80103912:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103916:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010391a:	8b 43 18             	mov    0x18(%ebx),%eax
8010391d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103924:	8b 43 18             	mov    0x18(%ebx),%eax
80103927:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010392e:	8b 43 18             	mov    0x18(%ebx),%eax
80103931:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103938:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010393b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103942:	00 
80103943:	c7 44 24 04 2d 78 10 	movl   $0x8010782d,0x4(%esp)
8010394a:	80 
8010394b:	89 04 24             	mov    %eax,(%esp)
8010394e:	e8 dd 0c 00 00       	call   80104630 <safestrcpy>
  p->cwd = namei("/");
80103953:	c7 04 24 36 78 10 80 	movl   $0x80107836,(%esp)
8010395a:	e8 a1 e6 ff ff       	call   80102000 <namei>
8010395f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103962:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103969:	e8 62 09 00 00       	call   801042d0 <acquire>

  p->state = RUNNABLE;
8010396e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103975:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010397c:	e8 7f 0a 00 00       	call   80104400 <release>
}
80103981:	83 c4 14             	add    $0x14,%esp
80103984:	5b                   	pop    %ebx
80103985:	5d                   	pop    %ebp
80103986:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103987:	c7 04 24 14 78 10 80 	movl   $0x80107814,(%esp)
8010398e:	e8 cd c9 ff ff       	call   80100360 <panic>
80103993:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801039a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801039b0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801039b2:	83 f9 00             	cmp    $0x0,%ecx
801039b5:	7e 39                	jle    801039f0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801039b7:	01 c1                	add    %eax,%ecx
801039b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801039bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801039c1:	8b 42 04             	mov    0x4(%edx),%eax
801039c4:	89 04 24             	mov    %eax,(%esp)
801039c7:	e8 34 35 00 00       	call   80106f00 <allocuvm>
801039cc:	85 c0                	test   %eax,%eax
801039ce:	74 40                	je     80103a10 <growproc+0x70>
801039d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801039d7:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801039d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039df:	89 04 24             	mov    %eax,(%esp)
801039e2:	e8 09 33 00 00       	call   80106cf0 <switchuvm>
  return 0;
801039e7:	31 c0                	xor    %eax,%eax
}
801039e9:	c9                   	leave  
801039ea:	c3                   	ret    
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039f0:	74 e5                	je     801039d7 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801039f2:	01 c1                	add    %eax,%ecx
801039f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801039f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801039fc:	8b 42 04             	mov    0x4(%edx),%eax
801039ff:	89 04 24             	mov    %eax,(%esp)
80103a02:	e8 e9 35 00 00       	call   80106ff0 <deallocuvm>
80103a07:	85 c0                	test   %eax,%eax
80103a09:	75 c5                	jne    801039d0 <growproc+0x30>
80103a0b:	90                   	nop
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103a15:	c9                   	leave  
80103a16:	c3                   	ret    
80103a17:	89 f6                	mov    %esi,%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a29:	e8 22 fd ff ff       	call   80103750 <allocproc>
80103a2e:	85 c0                	test   %eax,%eax
80103a30:	89 c3                	mov    %eax,%ebx
80103a32:	0f 84 d5 00 00 00    	je     80103b0d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a3e:	8b 10                	mov    (%eax),%edx
80103a40:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a44:	8b 40 04             	mov    0x4(%eax),%eax
80103a47:	89 04 24             	mov    %eax,(%esp)
80103a4a:	e8 71 36 00 00       	call   801070c0 <copyuvm>
80103a4f:	85 c0                	test   %eax,%eax
80103a51:	89 43 04             	mov    %eax,0x4(%ebx)
80103a54:	0f 84 ba 00 00 00    	je     80103b14 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a60:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a65:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a68:	8b 00                	mov    (%eax),%eax
80103a6a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a72:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103a75:	8b 70 18             	mov    0x18(%eax),%esi
80103a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a7a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a86:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103a90:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a94:	85 c0                	test   %eax,%eax
80103a96:	74 13                	je     80103aab <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103a98:	89 04 24             	mov    %eax,(%esp)
80103a9b:	e8 30 d3 ff ff       	call   80100dd0 <filedup>
80103aa0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103aa4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103aab:	83 c6 01             	add    $0x1,%esi
80103aae:	83 fe 10             	cmp    $0x10,%esi
80103ab1:	75 dd                	jne    80103a90 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103ab3:	8b 42 68             	mov    0x68(%edx),%eax
80103ab6:	89 04 24             	mov    %eax,(%esp)
80103ab9:	e8 c2 db ff ff       	call   80101680 <idup>
80103abe:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103ac1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ac7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103ace:	00 
80103acf:	83 c0 6c             	add    $0x6c,%eax
80103ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad6:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ad9:	89 04 24             	mov    %eax,(%esp)
80103adc:	e8 4f 0b 00 00       	call   80104630 <safestrcpy>

  pid = np->pid;
80103ae1:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103ae4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aeb:	e8 e0 07 00 00       	call   801042d0 <acquire>

  np->state = RUNNABLE;
80103af0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103af7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103afe:	e8 fd 08 00 00       	call   80104400 <release>

  return pid;
80103b03:	89 f0                	mov    %esi,%eax
}
80103b05:	83 c4 1c             	add    $0x1c,%esp
80103b08:	5b                   	pop    %ebx
80103b09:	5e                   	pop    %esi
80103b0a:	5f                   	pop    %edi
80103b0b:	5d                   	pop    %ebp
80103b0c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b12:	eb f1                	jmp    80103b05 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103b14:	8b 43 08             	mov    0x8(%ebx),%eax
80103b17:	89 04 24             	mov    %eax,(%esp)
80103b1a:	e8 e1 e8 ff ff       	call   80102400 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103b24:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b32:	eb d1                	jmp    80103b05 <fork+0xe5>
80103b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b40 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 14             	sub    $0x14,%esp
80103b47:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b48:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b49:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b50:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b55:	e8 76 07 00 00       	call   801042d0 <acquire>
80103b5a:	eb 0f                	jmp    80103b6b <scheduler+0x2b>
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b60:	83 c3 7c             	add    $0x7c,%ebx
80103b63:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103b69:	74 55                	je     80103bc0 <scheduler+0x80>
      if(p->state != RUNNABLE)
80103b6b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b6f:	75 ef                	jne    80103b60 <scheduler+0x20>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b71:	89 1c 24             	mov    %ebx,(%esp)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103b74:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b7b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b7e:	e8 6d 31 00 00       	call   80106cf0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103b83:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b86:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b91:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b97:	83 c0 04             	add    $0x4,%eax
80103b9a:	89 04 24             	mov    %eax,(%esp)
80103b9d:	e8 e9 0a 00 00       	call   8010468b <swtch>
      switchkvm();
80103ba2:	e8 29 31 00 00       	call   80106cd0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba7:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103bad:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103bb4:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb8:	75 b1                	jne    80103b6b <scheduler+0x2b>
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103bc0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103bc7:	e8 34 08 00 00       	call   80104400 <release>

  }
80103bcc:	e9 77 ff ff ff       	jmp    80103b48 <scheduler+0x8>
80103bd1:	eb 0d                	jmp    80103be0 <sched>
80103bd3:	90                   	nop
80103bd4:	90                   	nop
80103bd5:	90                   	nop
80103bd6:	90                   	nop
80103bd7:	90                   	nop
80103bd8:	90                   	nop
80103bd9:	90                   	nop
80103bda:	90                   	nop
80103bdb:	90                   	nop
80103bdc:	90                   	nop
80103bdd:	90                   	nop
80103bde:	90                   	nop
80103bdf:	90                   	nop

80103be0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	53                   	push   %ebx
80103be4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103be7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103bee:	e8 6d 07 00 00       	call   80104360 <holding>
80103bf3:	85 c0                	test   %eax,%eax
80103bf5:	74 4d                	je     80103c44 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103bf7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103bfd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103c04:	75 62                	jne    80103c68 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103c06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c0d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103c11:	74 49                	je     80103c5c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c13:	9c                   	pushf  
80103c14:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c15:	80 e5 02             	and    $0x2,%ch
80103c18:	75 36                	jne    80103c50 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103c1a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c20:	83 c2 1c             	add    $0x1c,%edx
80103c23:	8b 40 04             	mov    0x4(%eax),%eax
80103c26:	89 14 24             	mov    %edx,(%esp)
80103c29:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c2d:	e8 59 0a 00 00       	call   8010468b <swtch>
  cpu->intena = intena;
80103c32:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c38:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c3e:	83 c4 14             	add    $0x14,%esp
80103c41:	5b                   	pop    %ebx
80103c42:	5d                   	pop    %ebp
80103c43:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c44:	c7 04 24 38 78 10 80 	movl   $0x80107838,(%esp)
80103c4b:	e8 10 c7 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c50:	c7 04 24 64 78 10 80 	movl   $0x80107864,(%esp)
80103c57:	e8 04 c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c5c:	c7 04 24 56 78 10 80 	movl   $0x80107856,(%esp)
80103c63:	e8 f8 c6 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103c68:	c7 04 24 4a 78 10 80 	movl   $0x8010784a,(%esp)
80103c6f:	e8 ec c6 ff ff       	call   80100360 <panic>
80103c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c85:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c87:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c8a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c91:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103c97:	0f 84 01 01 00 00    	je     80103d9e <exit+0x11e>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103ca0:	8d 73 08             	lea    0x8(%ebx),%esi
80103ca3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103ca7:	85 c0                	test   %eax,%eax
80103ca9:	74 17                	je     80103cc2 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103cab:	89 04 24             	mov    %eax,(%esp)
80103cae:	e8 6d d1 ff ff       	call   80100e20 <fileclose>
      proc->ofile[fd] = 0;
80103cb3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cba:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103cc1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103cc2:	83 c3 01             	add    $0x1,%ebx
80103cc5:	83 fb 10             	cmp    $0x10,%ebx
80103cc8:	75 d6                	jne    80103ca0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cca:	e8 d1 ef ff ff       	call   80102ca0 <begin_op>
  iput(proc->cwd);
80103ccf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cd5:	8b 40 68             	mov    0x68(%eax),%eax
80103cd8:	89 04 24             	mov    %eax,(%esp)
80103cdb:	e8 e0 da ff ff       	call   801017c0 <iput>
  end_op();
80103ce0:	e8 2b f0 ff ff       	call   80102d10 <end_op>
  proc->cwd = 0;
80103ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ceb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103cf2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cf9:	e8 d2 05 00 00       	call   801042d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103cfe:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d05:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d0a:	8b 51 14             	mov    0x14(%ecx),%edx
80103d0d:	eb 0b                	jmp    80103d1a <exit+0x9a>
80103d0f:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d10:	83 c0 7c             	add    $0x7c,%eax
80103d13:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d18:	74 1c                	je     80103d36 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103d1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d1e:	75 f0                	jne    80103d10 <exit+0x90>
80103d20:	3b 50 20             	cmp    0x20(%eax),%edx
80103d23:	75 eb                	jne    80103d10 <exit+0x90>
      p->state = RUNNABLE;
80103d25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d2c:	83 c0 7c             	add    $0x7c,%eax
80103d2f:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d34:	75 e4                	jne    80103d1a <exit+0x9a>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d36:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d3c:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103d41:	eb 10                	jmp    80103d53 <exit+0xd3>
80103d43:	90                   	nop
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d48:	83 c2 7c             	add    $0x7c,%edx
80103d4b:	81 fa d4 4c 11 80    	cmp    $0x80114cd4,%edx
80103d51:	74 33                	je     80103d86 <exit+0x106>
    if(p->parent == proc){
80103d53:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d56:	75 f0                	jne    80103d48 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d58:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d5c:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d5f:	75 e7                	jne    80103d48 <exit+0xc8>
80103d61:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103d66:	eb 0a                	jmp    80103d72 <exit+0xf2>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d68:	83 c0 7c             	add    $0x7c,%eax
80103d6b:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d70:	74 d6                	je     80103d48 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103d72:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d76:	75 f0                	jne    80103d68 <exit+0xe8>
80103d78:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d7b:	75 eb                	jne    80103d68 <exit+0xe8>
      p->state = RUNNABLE;
80103d7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d84:	eb e2                	jmp    80103d68 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103d86:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103d8d:	e8 4e fe ff ff       	call   80103be0 <sched>
  panic("zombie exit");
80103d92:	c7 04 24 85 78 10 80 	movl   $0x80107885,(%esp)
80103d99:	e8 c2 c5 ff ff       	call   80100360 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103d9e:	c7 04 24 78 78 10 80 	movl   $0x80107878,(%esp)
80103da5:	e8 b6 c5 ff ff       	call   80100360 <panic>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103db6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103dbd:	e8 0e 05 00 00       	call   801042d0 <acquire>
  proc->state = RUNNABLE;
80103dc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dc8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103dcf:	e8 0c fe ff ff       	call   80103be0 <sched>
  release(&ptable.lock);
80103dd4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ddb:	e8 20 06 00 00       	call   80104400 <release>
}
80103de0:	c9                   	leave  
80103de1:	c3                   	ret    
80103de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	56                   	push   %esi
80103df4:	53                   	push   %ebx
80103df5:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103df8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103dfe:	8b 75 08             	mov    0x8(%ebp),%esi
80103e01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e04:	85 c0                	test   %eax,%eax
80103e06:	0f 84 8b 00 00 00    	je     80103e97 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103e0c:	85 db                	test   %ebx,%ebx
80103e0e:	74 7b                	je     80103e8b <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e10:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103e16:	74 50                	je     80103e68 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e18:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e1f:	e8 ac 04 00 00       	call   801042d0 <acquire>
    release(lk);
80103e24:	89 1c 24             	mov    %ebx,(%esp)
80103e27:	e8 d4 05 00 00       	call   80104400 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e32:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e35:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e3c:	e8 9f fd ff ff       	call   80103be0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e47:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e4e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e55:	e8 a6 05 00 00       	call   80104400 <release>
    acquire(lk);
80103e5a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103e5d:	83 c4 10             	add    $0x10,%esp
80103e60:	5b                   	pop    %ebx
80103e61:	5e                   	pop    %esi
80103e62:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e63:	e9 68 04 00 00       	jmp    801042d0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103e68:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e6b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e72:	e8 69 fd ff ff       	call   80103be0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e7d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	5b                   	pop    %ebx
80103e88:	5e                   	pop    %esi
80103e89:	5d                   	pop    %ebp
80103e8a:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e8b:	c7 04 24 97 78 10 80 	movl   $0x80107897,(%esp)
80103e92:	e8 c9 c4 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103e97:	c7 04 24 91 78 10 80 	movl   $0x80107891,(%esp)
80103e9e:	e8 bd c4 ff ff       	call   80100360 <panic>
80103ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
80103eb5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103eb8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ebf:	e8 0c 04 00 00       	call   801042d0 <acquire>
80103ec4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103eca:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecc:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103ed1:	eb 10                	jmp    80103ee3 <wait+0x33>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	83 c3 7c             	add    $0x7c,%ebx
80103edb:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103ee1:	74 1d                	je     80103f00 <wait+0x50>
      if(p->parent != proc)
80103ee3:	39 43 14             	cmp    %eax,0x14(%ebx)
80103ee6:	75 f0                	jne    80103ed8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103ee8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eec:	74 2f                	je     80103f1d <wait+0x6d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eee:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103ef1:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef6:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103efc:	75 e5                	jne    80103ee3 <wait+0x33>
80103efe:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f00:	85 d2                	test   %edx,%edx
80103f02:	74 6e                	je     80103f72 <wait+0xc2>
80103f04:	8b 50 24             	mov    0x24(%eax),%edx
80103f07:	85 d2                	test   %edx,%edx
80103f09:	75 67                	jne    80103f72 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f0b:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103f12:	80 
80103f13:	89 04 24             	mov    %eax,(%esp)
80103f16:	e8 d5 fe ff ff       	call   80103df0 <sleep>
  }
80103f1b:	eb a7                	jmp    80103ec4 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f1d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f20:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f23:	89 04 24             	mov    %eax,(%esp)
80103f26:	e8 d5 e4 ff ff       	call   80102400 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f2b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f35:	89 04 24             	mov    %eax,(%esp)
80103f38:	e8 d3 30 00 00       	call   80107010 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103f3d:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103f44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f64:	e8 97 04 00 00       	call   80104400 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f69:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f6c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f6e:	5b                   	pop    %ebx
80103f6f:	5e                   	pop    %esi
80103f70:	5d                   	pop    %ebp
80103f71:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103f72:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f79:	e8 82 04 00 00       	call   80104400 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f7e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f86:	5b                   	pop    %ebx
80103f87:	5e                   	pop    %esi
80103f88:	5d                   	pop    %ebp
80103f89:	c3                   	ret    
80103f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 14             	sub    $0x14,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f9a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103fa1:	e8 2a 03 00 00       	call   801042d0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa6:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103fab:	eb 0d                	jmp    80103fba <wakeup+0x2a>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
80103fb0:	83 c0 7c             	add    $0x7c,%eax
80103fb3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103fb8:	74 1e                	je     80103fd8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <wakeup+0x20>
80103fc0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fc3:	75 eb                	jne    80103fb0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcc:	83 c0 7c             	add    $0x7c,%eax
80103fcf:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103fd4:	75 e4                	jne    80103fba <wakeup+0x2a>
80103fd6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fd8:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103fdf:	83 c4 14             	add    $0x14,%esp
80103fe2:	5b                   	pop    %ebx
80103fe3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fe4:	e9 17 04 00 00       	jmp    80104400 <release>
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 14             	sub    $0x14,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103ffa:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104001:	e8 ca 02 00 00       	call   801042d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104006:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010400b:	eb 0d                	jmp    8010401a <kill+0x2a>
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
80104010:	83 c0 7c             	add    $0x7c,%eax
80104013:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104018:	74 36                	je     80104050 <kill+0x60>
    if(p->pid == pid){
8010401a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010401d:	75 f1                	jne    80104010 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010401f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104023:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010402a:	74 14                	je     80104040 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010402c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104033:	e8 c8 03 00 00       	call   80104400 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104038:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
8010403b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010403d:	5b                   	pop    %ebx
8010403e:	5d                   	pop    %ebp
8010403f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104040:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104047:	eb e3                	jmp    8010402c <kill+0x3c>
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104050:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104057:	e8 a4 03 00 00       	call   80104400 <release>
  return -1;
}
8010405c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
8010405f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104064:	5b                   	pop    %ebx
80104065:	5d                   	pop    %ebp
80104066:	c3                   	ret    
80104067:	89 f6                	mov    %esi,%esi
80104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104070 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
8010407b:	83 ec 4c             	sub    $0x4c,%esp
8010407e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104081:	eb 20                	jmp    801040a3 <procdump+0x33>
80104083:	90                   	nop
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104088:	c7 04 24 e6 77 10 80 	movl   $0x801077e6,(%esp)
8010408f:	e8 bc c5 ff ff       	call   80100650 <cprintf>
80104094:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104097:	81 fb 40 4d 11 80    	cmp    $0x80114d40,%ebx
8010409d:	0f 84 8d 00 00 00    	je     80104130 <procdump+0xc0>
    if(p->state == UNUSED)
801040a3:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040a6:	85 c0                	test   %eax,%eax
801040a8:	74 ea                	je     80104094 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040aa:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040ad:	ba a8 78 10 80       	mov    $0x801078a8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040b2:	77 11                	ja     801040c5 <procdump+0x55>
801040b4:	8b 14 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040bb:	b8 a8 78 10 80       	mov    $0x801078a8,%eax
801040c0:	85 d2                	test   %edx,%edx
801040c2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040c5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801040c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801040cc:	89 54 24 08          	mov    %edx,0x8(%esp)
801040d0:	c7 04 24 ac 78 10 80 	movl   $0x801078ac,(%esp)
801040d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801040db:	e8 70 c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801040e0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040e4:	75 a2                	jne    80104088 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801040ed:	8b 43 b0             	mov    -0x50(%ebx),%eax
801040f0:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040f3:	8b 40 0c             	mov    0xc(%eax),%eax
801040f6:	83 c0 08             	add    $0x8,%eax
801040f9:	89 04 24             	mov    %eax,(%esp)
801040fc:	e8 6f 01 00 00       	call   80104270 <getcallerpcs>
80104101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104108:	8b 17                	mov    (%edi),%edx
8010410a:	85 d2                	test   %edx,%edx
8010410c:	0f 84 76 ff ff ff    	je     80104088 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104112:	89 54 24 04          	mov    %edx,0x4(%esp)
80104116:	83 c7 04             	add    $0x4,%edi
80104119:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
80104120:	e8 2b c5 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104125:	39 f7                	cmp    %esi,%edi
80104127:	75 df                	jne    80104108 <procdump+0x98>
80104129:	e9 5a ff ff ff       	jmp    80104088 <procdump+0x18>
8010412e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104130:	83 c4 4c             	add    $0x4c,%esp
80104133:	5b                   	pop    %ebx
80104134:	5e                   	pop    %esi
80104135:	5f                   	pop    %edi
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
80104138:	66 90                	xchg   %ax,%ax
8010413a:	66 90                	xchg   %ax,%ax
8010413c:	66 90                	xchg   %ax,%ax
8010413e:	66 90                	xchg   %ax,%ax

80104140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 14             	sub    $0x14,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010414a:	c7 44 24 04 f8 78 10 	movl   $0x801078f8,0x4(%esp)
80104151:	80 
80104152:	8d 43 04             	lea    0x4(%ebx),%eax
80104155:	89 04 24             	mov    %eax,(%esp)
80104158:	e8 f3 00 00 00       	call   80104250 <initlock>
  lk->name = name;
8010415d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104160:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104166:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010416d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104170:	83 c4 14             	add    $0x14,%esp
80104173:	5b                   	pop    %ebx
80104174:	5d                   	pop    %ebp
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	83 ec 10             	sub    $0x10,%esp
80104188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010418b:	8d 73 04             	lea    0x4(%ebx),%esi
8010418e:	89 34 24             	mov    %esi,(%esp)
80104191:	e8 3a 01 00 00       	call   801042d0 <acquire>
  while (lk->locked) {
80104196:	8b 13                	mov    (%ebx),%edx
80104198:	85 d2                	test   %edx,%edx
8010419a:	74 16                	je     801041b2 <acquiresleep+0x32>
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801041a0:	89 74 24 04          	mov    %esi,0x4(%esp)
801041a4:	89 1c 24             	mov    %ebx,(%esp)
801041a7:	e8 44 fc ff ff       	call   80103df0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041ac:	8b 03                	mov    (%ebx),%eax
801041ae:	85 c0                	test   %eax,%eax
801041b0:	75 ee                	jne    801041a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041b2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801041b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041be:	8b 40 10             	mov    0x10(%eax),%eax
801041c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801041cd:	e9 2e 02 00 00       	jmp    80104400 <release>
801041d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	83 ec 10             	sub    $0x10,%esp
801041e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041eb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ee:	89 34 24             	mov    %esi,(%esp)
801041f1:	e8 da 00 00 00       	call   801042d0 <acquire>
  lk->locked = 0;
801041f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041fc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104203:	89 1c 24             	mov    %ebx,(%esp)
80104206:	e8 85 fd ff ff       	call   80103f90 <wakeup>
  release(&lk->lk);
8010420b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010420e:	83 c4 10             	add    $0x10,%esp
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104214:	e9 e7 01 00 00       	jmp    80104400 <release>
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	83 ec 10             	sub    $0x10,%esp
80104228:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010422b:	8d 73 04             	lea    0x4(%ebx),%esi
8010422e:	89 34 24             	mov    %esi,(%esp)
80104231:	e8 9a 00 00 00       	call   801042d0 <acquire>
  r = lk->locked;
80104236:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104238:	89 34 24             	mov    %esi,(%esp)
8010423b:	e8 c0 01 00 00       	call   80104400 <release>
  return r;
}
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	89 d8                	mov    %ebx,%eax
80104245:	5b                   	pop    %ebx
80104246:	5e                   	pop    %esi
80104247:	5d                   	pop    %ebp
80104248:	c3                   	ret    
80104249:	66 90                	xchg   %ax,%ax
8010424b:	66 90                	xchg   %ax,%ax
8010424d:	66 90                	xchg   %ax,%ax
8010424f:	90                   	nop

80104250 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104256:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010425f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    
8010426b:	90                   	nop
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104279:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010427a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010427d:	31 c0                	xor    %eax,%eax
8010427f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104280:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104286:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010428c:	77 1a                	ja     801042a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010428e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104291:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104294:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104297:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104299:	83 f8 0a             	cmp    $0xa,%eax
8010429c:	75 e2                	jne    80104280 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010429e:	5b                   	pop    %ebx
8010429f:	5d                   	pop    %ebp
801042a0:	c3                   	ret    
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042af:	83 c0 01             	add    $0x1,%eax
801042b2:	83 f8 0a             	cmp    $0xa,%eax
801042b5:	74 e7                	je     8010429e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042be:	83 c0 01             	add    $0x1,%eax
801042c1:	83 f8 0a             	cmp    $0xa,%eax
801042c4:	75 e2                	jne    801042a8 <getcallerpcs+0x38>
801042c6:	eb d6                	jmp    8010429e <getcallerpcs+0x2e>
801042c8:	90                   	nop
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	83 ec 18             	sub    $0x18,%esp
801042d6:	9c                   	pushf  
801042d7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042d8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042df:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801042e5:	85 d2                	test   %edx,%edx
801042e7:	75 0c                	jne    801042f5 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
801042e9:	81 e1 00 02 00 00    	and    $0x200,%ecx
801042ef:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801042f5:	83 c2 01             	add    $0x1,%edx
801042f8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042fe:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104301:	8b 0a                	mov    (%edx),%ecx
80104303:	85 c9                	test   %ecx,%ecx
80104305:	74 05                	je     8010430c <acquire+0x3c>
80104307:	3b 42 08             	cmp    0x8(%edx),%eax
8010430a:	74 3e                	je     8010434a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010430c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104311:	eb 08                	jmp    8010431b <acquire+0x4b>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	8b 55 08             	mov    0x8(%ebp),%edx
8010431b:	89 c8                	mov    %ecx,%eax
8010431d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104320:	85 c0                	test   %eax,%eax
80104322:	75 f4                	jne    80104318 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104324:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104329:	8b 45 08             	mov    0x8(%ebp),%eax
8010432c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104333:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104336:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104339:	89 44 24 04          	mov    %eax,0x4(%esp)
8010433d:	8d 45 08             	lea    0x8(%ebp),%eax
80104340:	89 04 24             	mov    %eax,(%esp)
80104343:	e8 28 ff ff ff       	call   80104270 <getcallerpcs>
}
80104348:	c9                   	leave  
80104349:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010434a:	c7 04 24 03 79 10 80 	movl   $0x80107903,(%esp)
80104351:	e8 0a c0 ff ff       	call   80100360 <panic>
80104356:	8d 76 00             	lea    0x0(%esi),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104360:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104361:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104363:	89 e5                	mov    %esp,%ebp
80104365:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104368:	8b 0a                	mov    (%edx),%ecx
8010436a:	85 c9                	test   %ecx,%ecx
8010436c:	74 0f                	je     8010437d <holding+0x1d>
8010436e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104374:	39 42 08             	cmp    %eax,0x8(%edx)
80104377:	0f 94 c0             	sete   %al
8010437a:	0f b6 c0             	movzbl %al,%eax
}
8010437d:	5d                   	pop    %ebp
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104383:	9c                   	pushf  
80104384:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104385:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104386:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010438c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104392:	85 d2                	test   %edx,%edx
80104394:	75 0c                	jne    801043a2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80104396:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010439c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801043a2:	83 c2 01             	add    $0x1,%edx
801043a5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801043ab:	5d                   	pop    %ebp
801043ac:	c3                   	ret    
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <popcli>:

void
popcli(void)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043b6:	9c                   	pushf  
801043b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043b8:	f6 c4 02             	test   $0x2,%ah
801043bb:	75 34                	jne    801043f1 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801043bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801043c3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
801043c9:	8d 51 ff             	lea    -0x1(%ecx),%edx
801043cc:	85 d2                	test   %edx,%edx
801043ce:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801043d4:	78 0f                	js     801043e5 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801043d6:	75 0b                	jne    801043e3 <popcli+0x33>
801043d8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801043de:	85 c0                	test   %eax,%eax
801043e0:	74 01                	je     801043e3 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
801043e2:	fb                   	sti    
    sti();
}
801043e3:	c9                   	leave  
801043e4:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801043e5:	c7 04 24 22 79 10 80 	movl   $0x80107922,(%esp)
801043ec:	e8 6f bf ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801043f1:	c7 04 24 0b 79 10 80 	movl   $0x8010790b,(%esp)
801043f8:	e8 63 bf ff ff       	call   80100360 <panic>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 18             	sub    $0x18,%esp
80104406:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104409:	8b 10                	mov    (%eax),%edx
8010440b:	85 d2                	test   %edx,%edx
8010440d:	74 0c                	je     8010441b <release+0x1b>
8010440f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104416:	39 50 08             	cmp    %edx,0x8(%eax)
80104419:	74 0d                	je     80104428 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010441b:	c7 04 24 29 79 10 80 	movl   $0x80107929,(%esp)
80104422:	e8 39 bf ff ff       	call   80100360 <panic>
80104427:	90                   	nop

  lk->pcs[0] = 0;
80104428:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010442f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104436:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010443b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104441:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104442:	e9 69 ff ff ff       	jmp    801043b0 <popcli>
80104447:	66 90                	xchg   %ax,%ax
80104449:	66 90                	xchg   %ax,%ax
8010444b:	66 90                	xchg   %ax,%ax
8010444d:	66 90                	xchg   %ax,%ax
8010444f:	90                   	nop

80104450 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 55 08             	mov    0x8(%ebp),%edx
80104456:	57                   	push   %edi
80104457:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010445a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010445b:	f6 c2 03             	test   $0x3,%dl
8010445e:	75 05                	jne    80104465 <memset+0x15>
80104460:	f6 c1 03             	test   $0x3,%cl
80104463:	74 13                	je     80104478 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104465:	89 d7                	mov    %edx,%edi
80104467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446a:	fc                   	cld    
8010446b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010446d:	5b                   	pop    %ebx
8010446e:	89 d0                	mov    %edx,%eax
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret    
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104478:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010447c:	c1 e9 02             	shr    $0x2,%ecx
8010447f:	89 f8                	mov    %edi,%eax
80104481:	89 fb                	mov    %edi,%ebx
80104483:	c1 e0 18             	shl    $0x18,%eax
80104486:	c1 e3 10             	shl    $0x10,%ebx
80104489:	09 d8                	or     %ebx,%eax
8010448b:	09 f8                	or     %edi,%eax
8010448d:	c1 e7 08             	shl    $0x8,%edi
80104490:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104492:	89 d7                	mov    %edx,%edi
80104494:	fc                   	cld    
80104495:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104497:	5b                   	pop    %ebx
80104498:	89 d0                	mov    %edx,%eax
8010449a:	5f                   	pop    %edi
8010449b:	5d                   	pop    %ebp
8010449c:	c3                   	ret    
8010449d:	8d 76 00             	lea    0x0(%esi),%esi

801044a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 45 10             	mov    0x10(%ebp),%eax
801044a6:	57                   	push   %edi
801044a7:	56                   	push   %esi
801044a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ab:	53                   	push   %ebx
801044ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044af:	85 c0                	test   %eax,%eax
801044b1:	8d 78 ff             	lea    -0x1(%eax),%edi
801044b4:	74 26                	je     801044dc <memcmp+0x3c>
    if(*s1 != *s2)
801044b6:	0f b6 03             	movzbl (%ebx),%eax
801044b9:	31 d2                	xor    %edx,%edx
801044bb:	0f b6 0e             	movzbl (%esi),%ecx
801044be:	38 c8                	cmp    %cl,%al
801044c0:	74 16                	je     801044d8 <memcmp+0x38>
801044c2:	eb 24                	jmp    801044e8 <memcmp+0x48>
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801044cd:	83 c2 01             	add    $0x1,%edx
801044d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044d4:	38 c8                	cmp    %cl,%al
801044d6:	75 10                	jne    801044e8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044d8:	39 fa                	cmp    %edi,%edx
801044da:	75 ec                	jne    801044c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044dc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801044dd:	31 c0                	xor    %eax,%eax
}
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801044e9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801044eb:	5e                   	pop    %esi
801044ec:	5f                   	pop    %edi
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop

801044f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	8b 45 08             	mov    0x8(%ebp),%eax
801044f7:	56                   	push   %esi
801044f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044fb:	53                   	push   %ebx
801044fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044ff:	39 c6                	cmp    %eax,%esi
80104501:	73 35                	jae    80104538 <memmove+0x48>
80104503:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104506:	39 c8                	cmp    %ecx,%eax
80104508:	73 2e                	jae    80104538 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010450a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010450c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010450f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104512:	74 1b                	je     8010452f <memmove+0x3f>
80104514:	f7 db                	neg    %ebx
80104516:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104519:	01 fb                	add    %edi,%ebx
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104520:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104524:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104527:	83 ea 01             	sub    $0x1,%edx
8010452a:	83 fa ff             	cmp    $0xffffffff,%edx
8010452d:	75 f1                	jne    80104520 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010452f:	5b                   	pop    %ebx
80104530:	5e                   	pop    %esi
80104531:	5f                   	pop    %edi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104538:	31 d2                	xor    %edx,%edx
8010453a:	85 db                	test   %ebx,%ebx
8010453c:	74 f1                	je     8010452f <memmove+0x3f>
8010453e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104540:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104544:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104547:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010454a:	39 da                	cmp    %ebx,%edx
8010454c:	75 f2                	jne    80104540 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010454e:	5b                   	pop    %ebx
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104563:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104564:	e9 87 ff ff ff       	jmp    801044f0 <memmove>
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104570 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	8b 75 10             	mov    0x10(%ebp),%esi
80104577:	53                   	push   %ebx
80104578:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010457b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010457e:	85 f6                	test   %esi,%esi
80104580:	74 30                	je     801045b2 <strncmp+0x42>
80104582:	0f b6 01             	movzbl (%ecx),%eax
80104585:	84 c0                	test   %al,%al
80104587:	74 2f                	je     801045b8 <strncmp+0x48>
80104589:	0f b6 13             	movzbl (%ebx),%edx
8010458c:	38 d0                	cmp    %dl,%al
8010458e:	75 46                	jne    801045d6 <strncmp+0x66>
80104590:	8d 51 01             	lea    0x1(%ecx),%edx
80104593:	01 ce                	add    %ecx,%esi
80104595:	eb 14                	jmp    801045ab <strncmp+0x3b>
80104597:	90                   	nop
80104598:	0f b6 02             	movzbl (%edx),%eax
8010459b:	84 c0                	test   %al,%al
8010459d:	74 31                	je     801045d0 <strncmp+0x60>
8010459f:	0f b6 19             	movzbl (%ecx),%ebx
801045a2:	83 c2 01             	add    $0x1,%edx
801045a5:	38 d8                	cmp    %bl,%al
801045a7:	75 17                	jne    801045c0 <strncmp+0x50>
    n--, p++, q++;
801045a9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045ab:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801045ad:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045b0:	75 e6                	jne    80104598 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045b2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045b3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045b5:	5e                   	pop    %esi
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
801045b8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045bb:	31 c0                	xor    %eax,%eax
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801045c0:	0f b6 d3             	movzbl %bl,%edx
801045c3:	29 d0                	sub    %edx,%eax
}
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
801045c8:	c3                   	ret    
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801045d4:	eb ea                	jmp    801045c0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045d6:	89 d3                	mov    %edx,%ebx
801045d8:	eb e6                	jmp    801045c0 <strncmp+0x50>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	8b 45 08             	mov    0x8(%ebp),%eax
801045e6:	56                   	push   %esi
801045e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045ea:	53                   	push   %ebx
801045eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801045ee:	89 c2                	mov    %eax,%edx
801045f0:	eb 19                	jmp    8010460b <strncpy+0x2b>
801045f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045f8:	83 c3 01             	add    $0x1,%ebx
801045fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045ff:	83 c2 01             	add    $0x1,%edx
80104602:	84 c9                	test   %cl,%cl
80104604:	88 4a ff             	mov    %cl,-0x1(%edx)
80104607:	74 09                	je     80104612 <strncpy+0x32>
80104609:	89 f1                	mov    %esi,%ecx
8010460b:	85 c9                	test   %ecx,%ecx
8010460d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104610:	7f e6                	jg     801045f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104612:	31 c9                	xor    %ecx,%ecx
80104614:	85 f6                	test   %esi,%esi
80104616:	7e 0f                	jle    80104627 <strncpy+0x47>
    *s++ = 0;
80104618:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010461c:	89 f3                	mov    %esi,%ebx
8010461e:	83 c1 01             	add    $0x1,%ecx
80104621:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104623:	85 db                	test   %ebx,%ebx
80104625:	7f f1                	jg     80104618 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104627:	5b                   	pop    %ebx
80104628:	5e                   	pop    %esi
80104629:	5d                   	pop    %ebp
8010462a:	c3                   	ret    
8010462b:	90                   	nop
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104636:	56                   	push   %esi
80104637:	8b 45 08             	mov    0x8(%ebp),%eax
8010463a:	53                   	push   %ebx
8010463b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010463e:	85 c9                	test   %ecx,%ecx
80104640:	7e 26                	jle    80104668 <safestrcpy+0x38>
80104642:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104646:	89 c1                	mov    %eax,%ecx
80104648:	eb 17                	jmp    80104661 <safestrcpy+0x31>
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104650:	83 c2 01             	add    $0x1,%edx
80104653:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104657:	83 c1 01             	add    $0x1,%ecx
8010465a:	84 db                	test   %bl,%bl
8010465c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010465f:	74 04                	je     80104665 <safestrcpy+0x35>
80104661:	39 f2                	cmp    %esi,%edx
80104663:	75 eb                	jne    80104650 <safestrcpy+0x20>
    ;
  *s = 0;
80104665:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <strlen>:

int
strlen(const char *s)
{
80104670:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104671:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104673:	89 e5                	mov    %esp,%ebp
80104675:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104678:	80 3a 00             	cmpb   $0x0,(%edx)
8010467b:	74 0c                	je     80104689 <strlen+0x19>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
80104680:	83 c0 01             	add    $0x1,%eax
80104683:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104687:	75 f7                	jne    80104680 <strlen+0x10>
    ;
  return n;
}
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    

8010468b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010468b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010468f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104693:	55                   	push   %ebp
  pushl %ebx
80104694:	53                   	push   %ebx
  pushl %esi
80104695:	56                   	push   %esi
  pushl %edi
80104696:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104697:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104699:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010469b:	5f                   	pop    %edi
  popl %esi
8010469c:	5e                   	pop    %esi
  popl %ebx
8010469d:	5b                   	pop    %ebx
  popl %ebp
8010469e:	5d                   	pop    %ebp
  ret
8010469f:	c3                   	ret    

801046a0 <fetchint>:


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
extern int sysCalls[];


int
fetchint(uint addr, int *ip)
{
801046a7:	55                   	push   %ebp
801046a8:	89 e5                	mov    %esp,%ebp
801046aa:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801046ad:	8b 12                	mov    (%edx),%edx
801046af:	39 c2                	cmp    %eax,%edx
801046b1:	76 15                	jbe    801046c8 <fetchint+0x28>
801046b3:	8d 48 04             	lea    0x4(%eax),%ecx
801046b6:	39 ca                	cmp    %ecx,%edx
801046b8:	72 0e                	jb     801046c8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801046ba:	8b 10                	mov    (%eax),%edx
801046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046bf:	89 10                	mov    %edx,(%eax)
  return 0;
801046c1:	31 c0                	xor    %eax,%eax
}
801046c3:	5d                   	pop    %ebp
801046c4:	c3                   	ret    
801046c5:	8d 76 00             	lea    0x0(%esi),%esi

int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801046c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
801046cd:	5d                   	pop    %ebp
801046ce:	c3                   	ret    
801046cf:	90                   	nop

801046d0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801046d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801046d6:	55                   	push   %ebp
801046d7:	89 e5                	mov    %esp,%ebp
801046d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801046dc:	39 08                	cmp    %ecx,(%eax)
801046de:	76 2c                	jbe    8010470c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801046e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801046e3:	89 c8                	mov    %ecx,%eax
801046e5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801046e7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046ee:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801046f0:	39 d1                	cmp    %edx,%ecx
801046f2:	73 18                	jae    8010470c <fetchstr+0x3c>
    if(*s == 0)
801046f4:	80 39 00             	cmpb   $0x0,(%ecx)
801046f7:	75 0c                	jne    80104705 <fetchstr+0x35>
801046f9:	eb 1d                	jmp    80104718 <fetchstr+0x48>
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104700:	80 38 00             	cmpb   $0x0,(%eax)
80104703:	74 13                	je     80104718 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104705:	83 c0 01             	add    $0x1,%eax
80104708:	39 c2                	cmp    %eax,%edx
8010470a:	77 f4                	ja     80104700 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010470c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104718:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104720:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104727:	55                   	push   %ebp
80104728:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010472a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010472d:	8b 42 18             	mov    0x18(%edx),%eax


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104730:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104732:	8b 40 44             	mov    0x44(%eax),%eax
80104735:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104738:	8d 48 04             	lea    0x4(%eax),%ecx


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010473b:	39 d1                	cmp    %edx,%ecx
8010473d:	73 19                	jae    80104758 <argint+0x38>
8010473f:	8d 48 08             	lea    0x8(%eax),%ecx
80104742:	39 ca                	cmp    %ecx,%edx
80104744:	72 12                	jb     80104758 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104746:	8b 50 04             	mov    0x4(%eax),%edx
80104749:	8b 45 0c             	mov    0xc(%ebp),%eax
8010474c:	89 10                	mov    %edx,(%eax)
  return 0;
8010474e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104750:	5d                   	pop    %ebp
80104751:	c3                   	ret    
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010475d:	5d                   	pop    %ebp
8010475e:	c3                   	ret    
8010475f:	90                   	nop

80104760 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104766:	55                   	push   %ebp
80104767:	89 e5                	mov    %esp,%ebp
80104769:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010476a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010476d:	8b 50 18             	mov    0x18(%eax),%edx
80104770:	8b 52 44             	mov    0x44(%edx),%edx
80104773:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104776:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010477d:	8d 59 04             	lea    0x4(%ecx),%ebx


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104780:	39 d3                	cmp    %edx,%ebx
80104782:	73 25                	jae    801047a9 <argptr+0x49>
80104784:	8d 59 08             	lea    0x8(%ecx),%ebx
80104787:	39 da                	cmp    %ebx,%edx
80104789:	72 1e                	jb     801047a9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010478b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
8010478e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104791:	85 db                	test   %ebx,%ebx
80104793:	78 14                	js     801047a9 <argptr+0x49>
80104795:	39 d1                	cmp    %edx,%ecx
80104797:	73 10                	jae    801047a9 <argptr+0x49>
80104799:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010479c:	01 cb                	add    %ecx,%ebx
8010479e:	39 d3                	cmp    %edx,%ebx
801047a0:	77 07                	ja     801047a9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
801047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801047a5:	89 08                	mov    %ecx,(%eax)
  return 0;
801047a7:	31 c0                	xor    %eax,%eax
}
801047a9:	5b                   	pop    %ebx
801047aa:	5d                   	pop    %ebp
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047b6:	55                   	push   %ebp
801047b7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047bc:	8b 50 18             	mov    0x18(%eax),%edx


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047bf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047c1:	8b 52 44             	mov    0x44(%edx),%edx
801047c4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801047c7:	8d 4a 04             	lea    0x4(%edx),%ecx


int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047ca:	39 c1                	cmp    %eax,%ecx
801047cc:	73 07                	jae    801047d5 <argstr+0x25>
801047ce:	8d 4a 08             	lea    0x8(%edx),%ecx
801047d1:	39 c8                	cmp    %ecx,%eax
801047d3:	73 0b                	jae    801047e0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801047d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801047e0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801047e3:	39 c1                	cmp    %eax,%ecx
801047e5:	73 ee                	jae    801047d5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801047e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801047ea:	89 c8                	mov    %ecx,%eax
801047ec:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801047ee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047f5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801047f7:	39 d1                	cmp    %edx,%ecx
801047f9:	73 da                	jae    801047d5 <argstr+0x25>
    if(*s == 0)
801047fb:	80 39 00             	cmpb   $0x0,(%ecx)
801047fe:	75 12                	jne    80104812 <argstr+0x62>
80104800:	eb 1e                	jmp    80104820 <argstr+0x70>
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104808:	80 38 00             	cmpb   $0x0,(%eax)
8010480b:	90                   	nop
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104810:	74 0e                	je     80104820 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104812:	83 c0 01             	add    $0x1,%eax
80104815:	39 c2                	cmp    %eax,%edx
80104817:	77 ef                	ja     80104808 <argstr+0x58>
80104819:	eb ba                	jmp    801047d5 <argstr+0x25>
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104820:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104822:	5d                   	pop    %ebp
80104823:	c3                   	ret    
80104824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010482a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104830 <syscall>:
[SYS_sysnumcall] sys_sysnumcall,
};

void
syscall(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104837:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010483e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104841:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104844:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104847:	83 f9 15             	cmp    $0x15,%ecx
8010484a:	0f 87 e8 00 00 00    	ja     80104938 <syscall+0x108>
80104850:	8b 0c 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%ecx
80104857:	85 c9                	test   %ecx,%ecx
80104859:	0f 84 d9 00 00 00    	je     80104938 <syscall+0x108>
	
          sysCalls[0]++;
8010485f:	83 05 e0 4c 11 80 01 	addl   $0x1,0x80114ce0
        if(num==SYS_fork){
80104866:	83 f8 01             	cmp    $0x1,%eax
80104869:	0f 84 01 01 00 00    	je     80104970 <syscall+0x140>
           sysCalls[num]++;
        }
        else if(num==SYS_exit){
8010486f:	83 f8 02             	cmp    $0x2,%eax
80104872:	0f 84 20 01 00 00    	je     80104998 <syscall+0x168>
           sysCalls[num]++;	
        }
        else if(num==SYS_wait){
80104878:	83 f8 03             	cmp    $0x3,%eax
8010487b:	0f 84 27 01 00 00    	je     801049a8 <syscall+0x178>
           sysCalls[num]++;
        }
        else if(num==SYS_pipe){
80104881:	83 f8 04             	cmp    $0x4,%eax
80104884:	0f 84 fe 00 00 00    	je     80104988 <syscall+0x158>
           sysCalls[num]++;
        }
        else if(num==SYS_read){
8010488a:	83 f8 05             	cmp    $0x5,%eax
8010488d:	0f 84 35 01 00 00    	je     801049c8 <syscall+0x198>
           sysCalls[num]++;
        }
        else if(num==SYS_kill){
80104893:	83 f8 06             	cmp    $0x6,%eax
80104896:	0f 84 3c 01 00 00    	je     801049d8 <syscall+0x1a8>
           sysCalls[num]++;
        }
        else if(num==SYS_exec){
8010489c:	83 f8 07             	cmp    $0x7,%eax
8010489f:	90                   	nop
801048a0:	0f 84 42 01 00 00    	je     801049e8 <syscall+0x1b8>
           sysCalls[num]++;
        }
        else if(num==SYS_fstat){
801048a6:	83 f8 08             	cmp    $0x8,%eax
801048a9:	0f 84 09 01 00 00    	je     801049b8 <syscall+0x188>
           sysCalls[num]++;
        }
        else if(num==SYS_chdir){
801048af:	83 f8 09             	cmp    $0x9,%eax
801048b2:	0f 84 40 01 00 00    	je     801049f8 <syscall+0x1c8>
           sysCalls[num]++;
        }
 	else if(num==SYS_dup){
801048b8:	83 f8 0a             	cmp    $0xa,%eax
801048bb:	0f 84 46 01 00 00    	je     80104a07 <syscall+0x1d7>
           sysCalls[num]++;
        }
	else if(num==SYS_getpid){
801048c1:	83 f8 0b             	cmp    $0xb,%eax
801048c4:	0f 84 4c 01 00 00    	je     80104a16 <syscall+0x1e6>
           sysCalls[num]++;
        }    
	else if(num==SYS_sbrk){
801048ca:	83 f8 0c             	cmp    $0xc,%eax
801048cd:	0f 84 52 01 00 00    	je     80104a25 <syscall+0x1f5>
           sysCalls[num]++;
        }
	else if(num==SYS_sleep){
801048d3:	83 f8 0d             	cmp    $0xd,%eax
801048d6:	0f 84 58 01 00 00    	je     80104a34 <syscall+0x204>
           sysCalls[num]++;
        }
	else if(num==SYS_uptime){
801048dc:	83 f8 0e             	cmp    $0xe,%eax
801048df:	90                   	nop
801048e0:	0f 84 5d 01 00 00    	je     80104a43 <syscall+0x213>
           sysCalls[num]++;
        }
	else if(num==SYS_open){
801048e6:	83 f8 0f             	cmp    $0xf,%eax
801048e9:	0f 84 63 01 00 00    	je     80104a52 <syscall+0x222>
           sysCalls[num]++;
        }
	else if(num==SYS_write){
801048ef:	83 f8 10             	cmp    $0x10,%eax
801048f2:	0f 84 69 01 00 00    	je     80104a61 <syscall+0x231>
           sysCalls[num]++;
        }
	else if(num==SYS_mknod){
801048f8:	83 f8 11             	cmp    $0x11,%eax
801048fb:	0f 84 6f 01 00 00    	je     80104a70 <syscall+0x240>
           sysCalls[num]++;
        }
	else if(num==SYS_unlink){
80104901:	83 f8 12             	cmp    $0x12,%eax
80104904:	0f 84 75 01 00 00    	je     80104a7f <syscall+0x24f>
           sysCalls[num]++;
        }
	else if(num==SYS_link){
8010490a:	83 f8 13             	cmp    $0x13,%eax
8010490d:	0f 84 7b 01 00 00    	je     80104a8e <syscall+0x25e>
           sysCalls[num]++;
        }
	else if(num==SYS_mkdir){
80104913:	83 f8 14             	cmp    $0x14,%eax
80104916:	0f 84 81 01 00 00    	je     80104a9d <syscall+0x26d>
           sysCalls[num]++;
        }
	else if(num==SYS_close){
8010491c:	83 f8 15             	cmp    $0x15,%eax
8010491f:	90                   	nop
80104920:	0f 84 86 01 00 00    	je     80104aac <syscall+0x27c>
           
	   sysCalls[num]++;
        }
	else if(num==SYS_sysnumcall){
80104926:	83 f8 16             	cmp    $0x16,%eax
80104929:	75 4c                	jne    80104977 <syscall+0x147>
           
	   sysCalls[num]++;
8010492b:	83 05 38 4d 11 80 01 	addl   $0x1,0x80114d38
80104932:	8b 5a 18             	mov    0x18(%edx),%ebx
80104935:	eb 40                	jmp    80104977 <syscall+0x147>
80104937:	90                   	nop
        }
	proc->tf->eax = syscalls[num]();
        
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104938:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
8010493c:	8d 42 6c             	lea    0x6c(%edx),%eax
8010493f:	89 44 24 08          	mov    %eax,0x8(%esp)
	   sysCalls[num]++;
        }
	proc->tf->eax = syscalls[num]();
        
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104943:	8b 42 10             	mov    0x10(%edx),%eax
80104946:	c7 04 24 31 79 10 80 	movl   $0x80107931,(%esp)
8010494d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104951:	e8 fa bc ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495c:	8b 40 18             	mov    0x18(%eax),%eax
8010495f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104966:	83 c4 14             	add    $0x14,%esp
80104969:	5b                   	pop    %ebx
8010496a:	5d                   	pop    %ebp
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
	
          sysCalls[0]++;
        if(num==SYS_fork){
           sysCalls[num]++;
80104970:	83 05 e4 4c 11 80 01 	addl   $0x1,0x80114ce4
        }
	else if(num==SYS_sysnumcall){
           
	   sysCalls[num]++;
        }
	proc->tf->eax = syscalls[num]();
80104977:	ff d1                	call   *%ecx
80104979:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010497c:	83 c4 14             	add    $0x14,%esp
8010497f:	5b                   	pop    %ebx
80104980:	5d                   	pop    %ebp
80104981:	c3                   	ret    
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        }
        else if(num==SYS_wait){
           sysCalls[num]++;
        }
        else if(num==SYS_pipe){
           sysCalls[num]++;
80104988:	83 05 f0 4c 11 80 01 	addl   $0x1,0x80114cf0
8010498f:	eb e6                	jmp    80104977 <syscall+0x147>
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          sysCalls[0]++;
        if(num==SYS_fork){
           sysCalls[num]++;
        }
        else if(num==SYS_exit){
           sysCalls[num]++;	
80104998:	83 05 e8 4c 11 80 01 	addl   $0x1,0x80114ce8
8010499f:	eb d6                	jmp    80104977 <syscall+0x147>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_wait){
           sysCalls[num]++;
801049a8:	83 05 ec 4c 11 80 01 	addl   $0x1,0x80114cec
801049af:	eb c6                	jmp    80104977 <syscall+0x147>
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_exec){
           sysCalls[num]++;
        }
        else if(num==SYS_fstat){
           sysCalls[num]++;
801049b8:	83 05 00 4d 11 80 01 	addl   $0x1,0x80114d00
801049bf:	8b 5a 18             	mov    0x18(%edx),%ebx
801049c2:	eb b3                	jmp    80104977 <syscall+0x147>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_pipe){
           sysCalls[num]++;
        }
        else if(num==SYS_read){
           sysCalls[num]++;
801049c8:	83 05 f4 4c 11 80 01 	addl   $0x1,0x80114cf4
801049cf:	eb a6                	jmp    80104977 <syscall+0x147>
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_kill){
           sysCalls[num]++;
801049d8:	83 05 f8 4c 11 80 01 	addl   $0x1,0x80114cf8
801049df:	8b 5a 18             	mov    0x18(%edx),%ebx
801049e2:	eb 93                	jmp    80104977 <syscall+0x147>
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_exec){
           sysCalls[num]++;
801049e8:	83 05 fc 4c 11 80 01 	addl   $0x1,0x80114cfc
801049ef:	8b 5a 18             	mov    0x18(%edx),%ebx
801049f2:	eb 83                	jmp    80104977 <syscall+0x147>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
        else if(num==SYS_fstat){
           sysCalls[num]++;
        }
        else if(num==SYS_chdir){
           sysCalls[num]++;
801049f8:	83 05 04 4d 11 80 01 	addl   $0x1,0x80114d04
801049ff:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a02:	e9 70 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
 	else if(num==SYS_dup){
           sysCalls[num]++;
80104a07:	83 05 08 4d 11 80 01 	addl   $0x1,0x80114d08
80104a0e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a11:	e9 61 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_getpid){
           sysCalls[num]++;
80104a16:	83 05 0c 4d 11 80 01 	addl   $0x1,0x80114d0c
80104a1d:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a20:	e9 52 ff ff ff       	jmp    80104977 <syscall+0x147>
        }    
	else if(num==SYS_sbrk){
           sysCalls[num]++;
80104a25:	83 05 10 4d 11 80 01 	addl   $0x1,0x80114d10
80104a2c:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a2f:	e9 43 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_sleep){
           sysCalls[num]++;
80104a34:	83 05 14 4d 11 80 01 	addl   $0x1,0x80114d14
80104a3b:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a3e:	e9 34 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_uptime){
           sysCalls[num]++;
80104a43:	83 05 18 4d 11 80 01 	addl   $0x1,0x80114d18
80104a4a:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a4d:	e9 25 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_open){
           sysCalls[num]++;
80104a52:	83 05 1c 4d 11 80 01 	addl   $0x1,0x80114d1c
80104a59:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a5c:	e9 16 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_write){
           sysCalls[num]++;
80104a61:	83 05 20 4d 11 80 01 	addl   $0x1,0x80114d20
80104a68:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a6b:	e9 07 ff ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_mknod){
           sysCalls[num]++;
80104a70:	83 05 24 4d 11 80 01 	addl   $0x1,0x80114d24
80104a77:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a7a:	e9 f8 fe ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_unlink){
           sysCalls[num]++;
80104a7f:	83 05 28 4d 11 80 01 	addl   $0x1,0x80114d28
80104a86:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a89:	e9 e9 fe ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_link){
           sysCalls[num]++;
80104a8e:	83 05 2c 4d 11 80 01 	addl   $0x1,0x80114d2c
80104a95:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a98:	e9 da fe ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_mkdir){
           sysCalls[num]++;
80104a9d:	83 05 30 4d 11 80 01 	addl   $0x1,0x80114d30
80104aa4:	8b 5a 18             	mov    0x18(%edx),%ebx
80104aa7:	e9 cb fe ff ff       	jmp    80104977 <syscall+0x147>
        }
	else if(num==SYS_close){
           
	   sysCalls[num]++;
80104aac:	83 05 34 4d 11 80 01 	addl   $0x1,0x80114d34
80104ab3:	8b 5a 18             	mov    0x18(%edx),%ebx
80104ab6:	e9 bc fe ff ff       	jmp    80104977 <syscall+0x147>
80104abb:	66 90                	xchg   %ax,%ax
80104abd:	66 90                	xchg   %ax,%ax
80104abf:	90                   	nop

80104ac0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 4c             	sub    $0x4c,%esp
80104ac9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104acc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104acf:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104ad2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ad6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104adc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104adf:	e8 3c d5 ff ff       	call   80102020 <nameiparent>
80104ae4:	85 c0                	test   %eax,%eax
80104ae6:	89 c6                	mov    %eax,%esi
80104ae8:	0f 84 f2 00 00 00    	je     80104be0 <create+0x120>
    return 0;
  ilock(dp);
80104aee:	89 04 24             	mov    %eax,(%esp)
80104af1:	e8 ba cb ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104af6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104af9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104afd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b01:	89 34 24             	mov    %esi,(%esp)
80104b04:	e8 b7 d1 ff ff       	call   80101cc0 <dirlookup>
80104b09:	85 c0                	test   %eax,%eax
80104b0b:	89 c7                	mov    %eax,%edi
80104b0d:	74 51                	je     80104b60 <create+0xa0>
    iunlockput(dp);
80104b0f:	89 34 24             	mov    %esi,(%esp)
80104b12:	e8 09 ce ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104b17:	89 3c 24             	mov    %edi,(%esp)
80104b1a:	e8 91 cb ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b1f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b24:	74 1a                	je     80104b40 <create+0x80>
      return ip;

    if(type == T_SFILE && ip->type == T_SFILE) {
80104b26:	66 83 7d c4 04       	cmpw   $0x4,-0x3c(%ebp)
80104b2b:	75 1e                	jne    80104b4b <create+0x8b>
80104b2d:	66 83 7f 50 04       	cmpw   $0x4,0x50(%edi)
80104b32:	89 f8                	mov    %edi,%eax
80104b34:	75 15                	jne    80104b4b <create+0x8b>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b36:	83 c4 4c             	add    $0x4c,%esp
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5f                   	pop    %edi
80104b3c:	5d                   	pop    %ebp
80104b3d:	c3                   	ret    
80104b3e:	66 90                	xchg   %ax,%ax
  ilock(dp);

  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
80104b40:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104b45:	0f 84 8d 00 00 00    	je     80104bd8 <create+0x118>

    if(type == T_SFILE && ip->type == T_SFILE) {
      return ip;
    }

    iunlockput(ip);
80104b4b:	89 3c 24             	mov    %edi,(%esp)
80104b4e:	e8 cd cd ff ff       	call   80101920 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b53:	83 c4 4c             	add    $0x4c,%esp
    if(type == T_SFILE && ip->type == T_SFILE) {
      return ip;
    }

    iunlockput(ip);
    return 0;
80104b56:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b58:	5b                   	pop    %ebx
80104b59:	5e                   	pop    %esi
80104b5a:	5f                   	pop    %edi
80104b5b:	5d                   	pop    %ebp
80104b5c:	c3                   	ret    
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104b60:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b64:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b68:	8b 06                	mov    (%esi),%eax
80104b6a:	89 04 24             	mov    %eax,(%esp)
80104b6d:	e8 ae c9 ff ff       	call   80101520 <ialloc>
80104b72:	85 c0                	test   %eax,%eax
80104b74:	89 c7                	mov    %eax,%edi
80104b76:	0f 84 c7 00 00 00    	je     80104c43 <create+0x183>
    panic("create: ialloc");

  ilock(ip);
80104b7c:	89 04 24             	mov    %eax,(%esp)
80104b7f:	e8 2c cb ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104b84:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b88:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104b8c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b90:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104b94:	b8 01 00 00 00       	mov    $0x1,%eax
80104b99:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104b9d:	89 3c 24             	mov    %edi,(%esp)
80104ba0:	e8 4b ca ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104ba5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104baa:	74 3c                	je     80104be8 <create+0x128>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104bac:	8b 47 04             	mov    0x4(%edi),%eax
80104baf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bb3:	89 34 24             	mov    %esi,(%esp)
80104bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bba:	e8 61 d3 ff ff       	call   80101f20 <dirlink>
80104bbf:	85 c0                	test   %eax,%eax
80104bc1:	78 74                	js     80104c37 <create+0x177>
    panic("create: dirlink");

  iunlockput(dp);
80104bc3:	89 34 24             	mov    %esi,(%esp)
80104bc6:	e8 55 cd ff ff       	call   80101920 <iunlockput>

  return ip;
}
80104bcb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104bce:	89 f8                	mov    %edi,%eax
}
80104bd0:	5b                   	pop    %ebx
80104bd1:	5e                   	pop    %esi
80104bd2:	5f                   	pop    %edi
80104bd3:	5d                   	pop    %ebp
80104bd4:	c3                   	ret    
80104bd5:	8d 76 00             	lea    0x0(%esi),%esi
80104bd8:	89 f8                	mov    %edi,%eax
80104bda:	e9 57 ff ff ff       	jmp    80104b36 <create+0x76>
80104bdf:	90                   	nop
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104be0:	31 c0                	xor    %eax,%eax
80104be2:	e9 4f ff ff ff       	jmp    80104b36 <create+0x76>
80104be7:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104be8:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104bed:	89 34 24             	mov    %esi,(%esp)
80104bf0:	e8 fb c9 ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bf5:	8b 47 04             	mov    0x4(%edi),%eax
80104bf8:	c7 44 24 04 d8 79 10 	movl   $0x801079d8,0x4(%esp)
80104bff:	80 
80104c00:	89 3c 24             	mov    %edi,(%esp)
80104c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c07:	e8 14 d3 ff ff       	call   80101f20 <dirlink>
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	78 1b                	js     80104c2b <create+0x16b>
80104c10:	8b 46 04             	mov    0x4(%esi),%eax
80104c13:	c7 44 24 04 d7 79 10 	movl   $0x801079d7,0x4(%esp)
80104c1a:	80 
80104c1b:	89 3c 24             	mov    %edi,(%esp)
80104c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c22:	e8 f9 d2 ff ff       	call   80101f20 <dirlink>
80104c27:	85 c0                	test   %eax,%eax
80104c29:	79 81                	jns    80104bac <create+0xec>
      panic("create dots");
80104c2b:	c7 04 24 cb 79 10 80 	movl   $0x801079cb,(%esp)
80104c32:	e8 29 b7 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104c37:	c7 04 24 da 79 10 80 	movl   $0x801079da,(%esp)
80104c3e:	e8 1d b7 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104c43:	c7 04 24 bc 79 10 80 	movl   $0x801079bc,(%esp)
80104c4a:	e8 11 b7 ff ff       	call   80100360 <panic>
80104c4f:	90                   	nop

80104c50 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	89 c6                	mov    %eax,%esi
80104c56:	53                   	push   %ebx
80104c57:	89 d3                	mov    %edx,%ebx
80104c59:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c6a:	e8 b1 fa ff ff       	call   80104720 <argint>
80104c6f:	85 c0                	test   %eax,%eax
80104c71:	78 35                	js     80104ca8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104c73:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104c76:	83 f9 0f             	cmp    $0xf,%ecx
80104c79:	77 2d                	ja     80104ca8 <argfd.constprop.0+0x58>
80104c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c81:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80104c85:	85 c0                	test   %eax,%eax
80104c87:	74 1f                	je     80104ca8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104c89:	85 f6                	test   %esi,%esi
80104c8b:	74 02                	je     80104c8f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104c8d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
80104c8f:	85 db                	test   %ebx,%ebx
80104c91:	74 0d                	je     80104ca0 <argfd.constprop.0+0x50>
    *pf = f;
80104c93:	89 03                	mov    %eax,(%ebx)
  return 0;
80104c95:	31 c0                	xor    %eax,%eax
}
80104c97:	83 c4 20             	add    $0x20,%esp
80104c9a:	5b                   	pop    %ebx
80104c9b:	5e                   	pop    %esi
80104c9c:	5d                   	pop    %ebp
80104c9d:	c3                   	ret    
80104c9e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ca0:	31 c0                	xor    %eax,%eax
80104ca2:	eb f3                	jmp    80104c97 <argfd.constprop.0+0x47>
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ca8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cad:	eb e8                	jmp    80104c97 <argfd.constprop.0+0x47>
80104caf:	90                   	nop

80104cb0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104cb0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	53                   	push   %ebx
80104cb6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cb9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cbc:	e8 8f ff ff ff       	call   80104c50 <argfd.constprop.0>
80104cc1:	85 c0                	test   %eax,%eax
80104cc3:	78 1b                	js     80104ce0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104cc8:	31 db                	xor    %ebx,%ebx
80104cca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104cd0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104cd4:	85 c9                	test   %ecx,%ecx
80104cd6:	74 18                	je     80104cf0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104cd8:	83 c3 01             	add    $0x1,%ebx
80104cdb:	83 fb 10             	cmp    $0x10,%ebx
80104cde:	75 f0                	jne    80104cd0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ce0:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ce8:	5b                   	pop    %ebx
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104cf0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104cf4:	89 14 24             	mov    %edx,(%esp)
80104cf7:	e8 d4 c0 ff ff       	call   80100dd0 <filedup>
  return fd;
}
80104cfc:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104cff:	89 d8                	mov    %ebx,%eax
}
80104d01:	5b                   	pop    %ebx
80104d02:	5d                   	pop    %ebp
80104d03:	c3                   	ret    
80104d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d10 <sys_read>:

int
sys_read(void)
{
80104d10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d11:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d1b:	e8 30 ff ff ff       	call   80104c50 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 54                	js     80104d78 <sys_read+0x68>
80104d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104d32:	e8 e9 f9 ff ff       	call   80104720 <argint>
80104d37:	85 c0                	test   %eax,%eax
80104d39:	78 3d                	js     80104d78 <sys_read+0x68>
80104d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d45:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d50:	e8 0b fa ff ff       	call   80104760 <argptr>
80104d55:	85 c0                	test   %eax,%eax
80104d57:	78 1f                	js     80104d78 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d63:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d6a:	89 04 24             	mov    %eax,(%esp)
80104d6d:	e8 be c1 ff ff       	call   80100f30 <fileread>
}
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104d7d:	c9                   	leave  
80104d7e:	c3                   	ret    
80104d7f:	90                   	nop

80104d80 <sys_write>:

int
sys_write(void)
{
80104d80:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d81:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d8b:	e8 c0 fe ff ff       	call   80104c50 <argfd.constprop.0>
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 54                	js     80104de8 <sys_write+0x68>
80104d94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d9b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104da2:	e8 79 f9 ff ff       	call   80104720 <argint>
80104da7:	85 c0                	test   %eax,%eax
80104da9:	78 3d                	js     80104de8 <sys_write+0x68>
80104dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104db5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104db9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dc0:	e8 9b f9 ff ff       	call   80104760 <argptr>
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 1f                	js     80104de8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104dda:	89 04 24             	mov    %eax,(%esp)
80104ddd:	e8 ee c1 ff ff       	call   80100fd0 <filewrite>
}
80104de2:	c9                   	leave  
80104de3:	c3                   	ret    
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104ded:	c9                   	leave  
80104dee:	c3                   	ret    
80104def:	90                   	nop

80104df0 <sys_close>:

int
sys_close(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104df6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104df9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfc:	e8 4f fe ff ff       	call   80104c50 <argfd.constprop.0>
80104e01:	85 c0                	test   %eax,%eax
80104e03:	78 23                	js     80104e28 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104e05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0e:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e15:	00 
  fileclose(f);
80104e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e19:	89 04 24             	mov    %eax,(%esp)
80104e1c:	e8 ff bf ff ff       	call   80100e20 <fileclose>
  return 0;
80104e21:	31 c0                	xor    %eax,%eax
}
80104e23:	c9                   	leave  
80104e24:	c3                   	ret    
80104e25:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e2d:	c9                   	leave  
80104e2e:	c3                   	ret    
80104e2f:	90                   	nop

80104e30 <sys_fstat>:

int
sys_fstat(void)
{
80104e30:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e31:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e38:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e3b:	e8 10 fe ff ff       	call   80104c50 <argfd.constprop.0>
80104e40:	85 c0                	test   %eax,%eax
80104e42:	78 34                	js     80104e78 <sys_fstat+0x48>
80104e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e47:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104e4e:	00 
80104e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e5a:	e8 01 f9 ff ff       	call   80104760 <argptr>
80104e5f:	85 c0                	test   %eax,%eax
80104e61:	78 15                	js     80104e78 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e6d:	89 04 24             	mov    %eax,(%esp)
80104e70:	e8 6b c0 ff ff       	call   80100ee0 <filestat>
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104e7d:	c9                   	leave  
80104e7e:	c3                   	ret    
80104e7f:	90                   	nop

80104e80 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e89:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e97:	e8 14 f9 ff ff       	call   801047b0 <argstr>
80104e9c:	85 c0                	test   %eax,%eax
80104e9e:	0f 88 e6 00 00 00    	js     80104f8a <sys_link+0x10a>
80104ea4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104eb2:	e8 f9 f8 ff ff       	call   801047b0 <argstr>
80104eb7:	85 c0                	test   %eax,%eax
80104eb9:	0f 88 cb 00 00 00    	js     80104f8a <sys_link+0x10a>
    return -1;

  begin_op();
80104ebf:	e8 dc dd ff ff       	call   80102ca0 <begin_op>
  if((ip = namei(old)) == 0){
80104ec4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ec7:	89 04 24             	mov    %eax,(%esp)
80104eca:	e8 31 d1 ff ff       	call   80102000 <namei>
80104ecf:	85 c0                	test   %eax,%eax
80104ed1:	89 c3                	mov    %eax,%ebx
80104ed3:	0f 84 ac 00 00 00    	je     80104f85 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104ed9:	89 04 24             	mov    %eax,(%esp)
80104edc:	e8 cf c7 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104ee1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ee6:	0f 84 91 00 00 00    	je     80104f7d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104eec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ef1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ef4:	89 1c 24             	mov    %ebx,(%esp)
80104ef7:	e8 f4 c6 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104efc:	89 1c 24             	mov    %ebx,(%esp)
80104eff:	e8 7c c8 ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104f04:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104f07:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104f0b:	89 04 24             	mov    %eax,(%esp)
80104f0e:	e8 0d d1 ff ff       	call   80102020 <nameiparent>
80104f13:	85 c0                	test   %eax,%eax
80104f15:	89 c6                	mov    %eax,%esi
80104f17:	74 4f                	je     80104f68 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104f19:	89 04 24             	mov    %eax,(%esp)
80104f1c:	e8 8f c7 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f21:	8b 03                	mov    (%ebx),%eax
80104f23:	39 06                	cmp    %eax,(%esi)
80104f25:	75 39                	jne    80104f60 <sys_link+0xe0>
80104f27:	8b 43 04             	mov    0x4(%ebx),%eax
80104f2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104f2e:	89 34 24             	mov    %esi,(%esp)
80104f31:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f35:	e8 e6 cf ff ff       	call   80101f20 <dirlink>
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	78 22                	js     80104f60 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f3e:	89 34 24             	mov    %esi,(%esp)
80104f41:	e8 da c9 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104f46:	89 1c 24             	mov    %ebx,(%esp)
80104f49:	e8 72 c8 ff ff       	call   801017c0 <iput>

  end_op();
80104f4e:	e8 bd dd ff ff       	call   80102d10 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f53:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104f56:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f58:	5b                   	pop    %ebx
80104f59:	5e                   	pop    %esi
80104f5a:	5f                   	pop    %edi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104f60:	89 34 24             	mov    %esi,(%esp)
80104f63:	e8 b8 c9 ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104f68:	89 1c 24             	mov    %ebx,(%esp)
80104f6b:	e8 40 c7 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104f70:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f75:	89 1c 24             	mov    %ebx,(%esp)
80104f78:	e8 73 c6 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104f7d:	89 1c 24             	mov    %ebx,(%esp)
80104f80:	e8 9b c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f85:	e8 86 dd ff ff       	call   80102d10 <end_op>
  return -1;
}
80104f8a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f92:	5b                   	pop    %ebx
80104f93:	5e                   	pop    %esi
80104f94:	5f                   	pop    %edi
80104f95:	5d                   	pop    %ebp
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
80104fa6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104fa9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fb7:	e8 f4 f7 ff ff       	call   801047b0 <argstr>
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	0f 88 76 01 00 00    	js     8010513a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104fc4:	e8 d7 dc ff ff       	call   80102ca0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104fcc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fcf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104fd3:	89 04 24             	mov    %eax,(%esp)
80104fd6:	e8 45 d0 ff ff       	call   80102020 <nameiparent>
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104fe0:	0f 84 4f 01 00 00    	je     80105135 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104fe6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104fe9:	89 34 24             	mov    %esi,(%esp)
80104fec:	e8 bf c6 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ff1:	c7 44 24 04 d8 79 10 	movl   $0x801079d8,0x4(%esp)
80104ff8:	80 
80104ff9:	89 1c 24             	mov    %ebx,(%esp)
80104ffc:	e8 8f cc ff ff       	call   80101c90 <namecmp>
80105001:	85 c0                	test   %eax,%eax
80105003:	0f 84 21 01 00 00    	je     8010512a <sys_unlink+0x18a>
80105009:	c7 44 24 04 d7 79 10 	movl   $0x801079d7,0x4(%esp)
80105010:	80 
80105011:	89 1c 24             	mov    %ebx,(%esp)
80105014:	e8 77 cc ff ff       	call   80101c90 <namecmp>
80105019:	85 c0                	test   %eax,%eax
8010501b:	0f 84 09 01 00 00    	je     8010512a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105021:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105024:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105028:	89 44 24 08          	mov    %eax,0x8(%esp)
8010502c:	89 34 24             	mov    %esi,(%esp)
8010502f:	e8 8c cc ff ff       	call   80101cc0 <dirlookup>
80105034:	85 c0                	test   %eax,%eax
80105036:	89 c3                	mov    %eax,%ebx
80105038:	0f 84 ec 00 00 00    	je     8010512a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
8010503e:	89 04 24             	mov    %eax,(%esp)
80105041:	e8 6a c6 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80105046:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010504b:	0f 8e 24 01 00 00    	jle    80105175 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105051:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105056:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105059:	74 7d                	je     801050d8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010505b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105062:	00 
80105063:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010506a:	00 
8010506b:	89 34 24             	mov    %esi,(%esp)
8010506e:	e8 dd f3 ff ff       	call   80104450 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105073:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105076:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010507d:	00 
8010507e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105082:	89 44 24 08          	mov    %eax,0x8(%esp)
80105086:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105089:	89 04 24             	mov    %eax,(%esp)
8010508c:	e8 1f ca ff ff       	call   80101ab0 <writei>
80105091:	83 f8 10             	cmp    $0x10,%eax
80105094:	0f 85 cf 00 00 00    	jne    80105169 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010509a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010509f:	0f 84 a3 00 00 00    	je     80105148 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801050a5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801050a8:	89 04 24             	mov    %eax,(%esp)
801050ab:	e8 70 c8 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
801050b0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b5:	89 1c 24             	mov    %ebx,(%esp)
801050b8:	e8 33 c5 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801050bd:	89 1c 24             	mov    %ebx,(%esp)
801050c0:	e8 5b c8 ff ff       	call   80101920 <iunlockput>

  end_op();
801050c5:	e8 46 dc ff ff       	call   80102d10 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801050ca:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
801050cd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5f                   	pop    %edi
801050d2:	5d                   	pop    %ebp
801050d3:	c3                   	ret    
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050d8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050dc:	0f 86 79 ff ff ff    	jbe    8010505b <sys_unlink+0xbb>
801050e2:	bf 20 00 00 00       	mov    $0x20,%edi
801050e7:	eb 15                	jmp    801050fe <sys_unlink+0x15e>
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050f0:	8d 57 10             	lea    0x10(%edi),%edx
801050f3:	3b 53 58             	cmp    0x58(%ebx),%edx
801050f6:	0f 83 5f ff ff ff    	jae    8010505b <sys_unlink+0xbb>
801050fc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050fe:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105105:	00 
80105106:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010510a:	89 74 24 04          	mov    %esi,0x4(%esp)
8010510e:	89 1c 24             	mov    %ebx,(%esp)
80105111:	e8 5a c8 ff ff       	call   80101970 <readi>
80105116:	83 f8 10             	cmp    $0x10,%eax
80105119:	75 42                	jne    8010515d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010511b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105120:	74 ce                	je     801050f0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105122:	89 1c 24             	mov    %ebx,(%esp)
80105125:	e8 f6 c7 ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010512a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010512d:	89 04 24             	mov    %eax,(%esp)
80105130:	e8 eb c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105135:	e8 d6 db ff ff       	call   80102d10 <end_op>
  return -1;
}
8010513a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
8010513d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105142:	5b                   	pop    %ebx
80105143:	5e                   	pop    %esi
80105144:	5f                   	pop    %edi
80105145:	5d                   	pop    %ebp
80105146:	c3                   	ret    
80105147:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105148:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010514b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105150:	89 04 24             	mov    %eax,(%esp)
80105153:	e8 98 c4 ff ff       	call   801015f0 <iupdate>
80105158:	e9 48 ff ff ff       	jmp    801050a5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010515d:	c7 04 24 fc 79 10 80 	movl   $0x801079fc,(%esp)
80105164:	e8 f7 b1 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105169:	c7 04 24 0e 7a 10 80 	movl   $0x80107a0e,(%esp)
80105170:	e8 eb b1 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105175:	c7 04 24 ea 79 10 80 	movl   $0x801079ea,(%esp)
8010517c:	e8 df b1 ff ff       	call   80100360 <panic>
80105181:	eb 0d                	jmp    80105190 <sys_open>
80105183:	90                   	nop
80105184:	90                   	nop
80105185:	90                   	nop
80105186:	90                   	nop
80105187:	90                   	nop
80105188:	90                   	nop
80105189:	90                   	nop
8010518a:	90                   	nop
8010518b:	90                   	nop
8010518c:	90                   	nop
8010518d:	90                   	nop
8010518e:	90                   	nop
8010518f:	90                   	nop

80105190 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105199:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010519c:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051a7:	e8 04 f6 ff ff       	call   801047b0 <argstr>
801051ac:	85 c0                	test   %eax,%eax
801051ae:	0f 88 89 00 00 00    	js     8010523d <sys_open+0xad>
801051b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051c2:	e8 59 f5 ff ff       	call   80104720 <argint>
801051c7:	85 c0                	test   %eax,%eax
801051c9:	78 72                	js     8010523d <sys_open+0xad>
    return -1;

  begin_op();
801051cb:	e8 d0 da ff ff       	call   80102ca0 <begin_op>

  if(omode & O_CREATE){
801051d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051d3:	f6 c4 02             	test   $0x2,%ah
801051d6:	0f 84 bc 00 00 00    	je     80105298 <sys_open+0x108>
	if (omode & O_SFILE) {
      // creates a SFILE
      if((ip = create(path, T_SFILE, 0, 0)) == 0)
801051dc:	31 c9                	xor    %ecx,%ecx
    return -1;

  begin_op();

  if(omode & O_CREATE){
	if (omode & O_SFILE) {
801051de:	f6 c4 04             	test   $0x4,%ah
      // creates a SFILE
      if((ip = create(path, T_SFILE, 0, 0)) == 0)
801051e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051e8:	ba 04 00 00 00       	mov    $0x4,%edx
    return -1;

  begin_op();

  if(omode & O_CREATE){
	if (omode & O_SFILE) {
801051ed:	74 61                	je     80105250 <sys_open+0xc0>
      if((ip = create(path, T_SFILE, 0, 0)) == 0)
        return -1;
	}
    else {
      // creates a REGULAR file
      if((ip = create(path, T_FILE, 0, 0)) == 0)
801051ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051f2:	e8 c9 f8 ff ff       	call   80104ac0 <create>
801051f7:	85 c0                	test   %eax,%eax
801051f9:	89 c6                	mov    %eax,%esi
801051fb:	74 40                	je     8010523d <sys_open+0xad>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051fd:	e8 5e bb ff ff       	call   80100d60 <filealloc>
80105202:	85 c0                	test   %eax,%eax
80105204:	89 c7                	mov    %eax,%edi
80105206:	74 28                	je     80105230 <sys_open+0xa0>
80105208:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010520f:	31 db                	xor    %ebx,%ebx
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105218:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
8010521c:	85 c0                	test   %eax,%eax
8010521e:	74 38                	je     80105258 <sys_open+0xc8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105220:	83 c3 01             	add    $0x1,%ebx
80105223:	83 fb 10             	cmp    $0x10,%ebx
80105226:	75 f0                	jne    80105218 <sys_open+0x88>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105228:	89 3c 24             	mov    %edi,(%esp)
8010522b:	e8 f0 bb ff ff       	call   80100e20 <fileclose>
    iunlockput(ip);
80105230:	89 34 24             	mov    %esi,(%esp)
80105233:	e8 e8 c6 ff ff       	call   80101920 <iunlockput>
    end_op();
80105238:	e8 d3 da ff ff       	call   80102d10 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010523d:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105245:	5b                   	pop    %ebx
80105246:	5e                   	pop    %esi
80105247:	5f                   	pop    %edi
80105248:	5d                   	pop    %ebp
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if((ip = create(path, T_SFILE, 0, 0)) == 0)
        return -1;
	}
    else {
      // creates a REGULAR file
      if((ip = create(path, T_FILE, 0, 0)) == 0)
80105250:	ba 02 00 00 00       	mov    $0x2,%edx
80105255:	eb 98                	jmp    801051ef <sys_open+0x5f>
80105257:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105258:	89 7c 9a 28          	mov    %edi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010525c:	89 34 24             	mov    %esi,(%esp)
8010525f:	e8 1c c5 ff ff       	call   80101780 <iunlock>
  end_op();
80105264:	e8 a7 da ff ff       	call   80102d10 <end_op>

  f->type = FD_INODE;
80105269:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010526f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105272:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105275:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010527c:	89 d0                	mov    %edx,%eax
8010527e:	83 e0 01             	and    $0x1,%eax
80105281:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105284:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105287:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010528a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010528c:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105290:	83 c4 2c             	add    $0x2c,%esp
80105293:	5b                   	pop    %ebx
80105294:	5e                   	pop    %esi
80105295:	5f                   	pop    %edi
80105296:	5d                   	pop    %ebp
80105297:	c3                   	ret    
        return -1;
    }
  }
    
    else {
    if((ip = namei(path)) == 0){
80105298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010529b:	89 04 24             	mov    %eax,(%esp)
8010529e:	e8 5d cd ff ff       	call   80102000 <namei>
801052a3:	85 c0                	test   %eax,%eax
801052a5:	89 c6                	mov    %eax,%esi
801052a7:	74 8f                	je     80105238 <sys_open+0xa8>
      end_op();
      return -1;
    }
    ilock(ip);
801052a9:	89 04 24             	mov    %eax,(%esp)
801052ac:	e8 ff c3 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052b1:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052b6:	0f 85 41 ff ff ff    	jne    801051fd <sys_open+0x6d>
801052bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052bf:	85 d2                	test   %edx,%edx
801052c1:	0f 84 36 ff ff ff    	je     801051fd <sys_open+0x6d>
801052c7:	e9 64 ff ff ff       	jmp    80105230 <sys_open+0xa0>
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052d6:	e8 c5 d9 ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052de:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052e9:	e8 c2 f4 ff ff       	call   801047b0 <argstr>
801052ee:	85 c0                	test   %eax,%eax
801052f0:	78 2e                	js     80105320 <sys_mkdir+0x50>
801052f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f5:	31 c9                	xor    %ecx,%ecx
801052f7:	ba 01 00 00 00       	mov    $0x1,%edx
801052fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105303:	e8 b8 f7 ff ff       	call   80104ac0 <create>
80105308:	85 c0                	test   %eax,%eax
8010530a:	74 14                	je     80105320 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010530c:	89 04 24             	mov    %eax,(%esp)
8010530f:	e8 0c c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105314:	e8 f7 d9 ff ff       	call   80102d10 <end_op>
  return 0;
80105319:	31 c0                	xor    %eax,%eax
}
8010531b:	c9                   	leave  
8010531c:	c3                   	ret    
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105320:	e8 eb d9 ff ff       	call   80102d10 <end_op>
    return -1;
80105325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010532a:	c9                   	leave  
8010532b:	c3                   	ret    
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105330 <sys_mknod>:

int
sys_mknod(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105336:	e8 65 d9 ff ff       	call   80102ca0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010533b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010533e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105342:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105349:	e8 62 f4 ff ff       	call   801047b0 <argstr>
8010534e:	85 c0                	test   %eax,%eax
80105350:	78 5e                	js     801053b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105352:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105355:	89 44 24 04          	mov    %eax,0x4(%esp)
80105359:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105360:	e8 bb f3 ff ff       	call   80104720 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105365:	85 c0                	test   %eax,%eax
80105367:	78 47                	js     801053b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105370:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105377:	e8 a4 f3 ff ff       	call   80104720 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 30                	js     801053b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105380:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105384:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105389:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010538d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105390:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105393:	e8 28 f7 ff ff       	call   80104ac0 <create>
80105398:	85 c0                	test   %eax,%eax
8010539a:	74 14                	je     801053b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539c:	89 04 24             	mov    %eax,(%esp)
8010539f:	e8 7c c5 ff ff       	call   80101920 <iunlockput>
  end_op();
801053a4:	e8 67 d9 ff ff       	call   80102d10 <end_op>
  return 0;
801053a9:	31 c0                	xor    %eax,%eax
}
801053ab:	c9                   	leave  
801053ac:	c3                   	ret    
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801053b0:	e8 5b d9 ff ff       	call   80102d10 <end_op>
    return -1;
801053b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ba:	c9                   	leave  
801053bb:	c3                   	ret    
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_chdir>:

int
sys_chdir(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053c7:	e8 d4 d8 ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801053d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053da:	e8 d1 f3 ff ff       	call   801047b0 <argstr>
801053df:	85 c0                	test   %eax,%eax
801053e1:	78 5a                	js     8010543d <sys_chdir+0x7d>
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	89 04 24             	mov    %eax,(%esp)
801053e9:	e8 12 cc ff ff       	call   80102000 <namei>
801053ee:	85 c0                	test   %eax,%eax
801053f0:	89 c3                	mov    %eax,%ebx
801053f2:	74 49                	je     8010543d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
801053f4:	89 04 24             	mov    %eax,(%esp)
801053f7:	e8 b4 c2 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801053fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105401:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80105404:	75 32                	jne    80105438 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105406:	e8 75 c3 ff ff       	call   80101780 <iunlock>
  iput(proc->cwd);
8010540b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105411:	8b 40 68             	mov    0x68(%eax),%eax
80105414:	89 04 24             	mov    %eax,(%esp)
80105417:	e8 a4 c3 ff ff       	call   801017c0 <iput>
  end_op();
8010541c:	e8 ef d8 ff ff       	call   80102d10 <end_op>
  proc->cwd = ip;
80105421:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105427:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
8010542a:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
8010542d:	31 c0                	xor    %eax,%eax
}
8010542f:	5b                   	pop    %ebx
80105430:	5d                   	pop    %ebp
80105431:	c3                   	ret    
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105438:	e8 e3 c4 ff ff       	call   80101920 <iunlockput>
    end_op();
8010543d:	e8 ce d8 ff ff       	call   80102d10 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105442:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010544a:	5b                   	pop    %ebx
8010544b:	5d                   	pop    %ebp
8010544c:	c3                   	ret    
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <sys_exec>:

int
sys_exec(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
80105456:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010545c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105462:	89 44 24 04          	mov    %eax,0x4(%esp)
80105466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010546d:	e8 3e f3 ff ff       	call   801047b0 <argstr>
80105472:	85 c0                	test   %eax,%eax
80105474:	0f 88 84 00 00 00    	js     801054fe <sys_exec+0xae>
8010547a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105480:	89 44 24 04          	mov    %eax,0x4(%esp)
80105484:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010548b:	e8 90 f2 ff ff       	call   80104720 <argint>
80105490:	85 c0                	test   %eax,%eax
80105492:	78 6a                	js     801054fe <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105494:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010549a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010549c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801054a3:	00 
801054a4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801054aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054b1:	00 
801054b2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054b8:	89 04 24             	mov    %eax,(%esp)
801054bb:	e8 90 ef ff ff       	call   80104450 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801054ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801054cd:	89 04 24             	mov    %eax,(%esp)
801054d0:	e8 cb f1 ff ff       	call   801046a0 <fetchint>
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 25                	js     801054fe <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801054d9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054df:	85 c0                	test   %eax,%eax
801054e1:	74 2d                	je     80105510 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054e3:	89 74 24 04          	mov    %esi,0x4(%esp)
801054e7:	89 04 24             	mov    %eax,(%esp)
801054ea:	e8 e1 f1 ff ff       	call   801046d0 <fetchstr>
801054ef:	85 c0                	test   %eax,%eax
801054f1:	78 0b                	js     801054fe <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801054f3:	83 c3 01             	add    $0x1,%ebx
801054f6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801054f9:	83 fb 20             	cmp    $0x20,%ebx
801054fc:	75 c2                	jne    801054c0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054fe:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105509:	5b                   	pop    %ebx
8010550a:	5e                   	pop    %esi
8010550b:	5f                   	pop    %edi
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    
8010550e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105510:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105516:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105520:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105527:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010552b:	89 04 24             	mov    %eax,(%esp)
8010552e:	e8 7d b4 ff ff       	call   801009b0 <exec>
}
80105533:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105539:	5b                   	pop    %ebx
8010553a:	5e                   	pop    %esi
8010553b:	5f                   	pop    %edi
8010553c:	5d                   	pop    %ebp
8010553d:	c3                   	ret    
8010553e:	66 90                	xchg   %ax,%ax

80105540 <sys_pipe>:

int
sys_pipe(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
80105546:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105549:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010554c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105553:	00 
80105554:	89 44 24 04          	mov    %eax,0x4(%esp)
80105558:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010555f:	e8 fc f1 ff ff       	call   80104760 <argptr>
80105564:	85 c0                	test   %eax,%eax
80105566:	78 7a                	js     801055e2 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105568:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010556b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010556f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105572:	89 04 24             	mov    %eax,(%esp)
80105575:	e8 56 de ff ff       	call   801033d0 <pipealloc>
8010557a:	85 c0                	test   %eax,%eax
8010557c:	78 64                	js     801055e2 <sys_pipe+0xa2>
8010557e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105585:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105587:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010558a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010558e:	85 d2                	test   %edx,%edx
80105590:	74 16                	je     801055a8 <sys_pipe+0x68>
80105592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105598:	83 c0 01             	add    $0x1,%eax
8010559b:	83 f8 10             	cmp    $0x10,%eax
8010559e:	74 2f                	je     801055cf <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
801055a0:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801055a4:	85 d2                	test   %edx,%edx
801055a6:	75 f0                	jne    80105598 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801055ab:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055ae:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801055b0:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801055b8:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801055bd:	74 31                	je     801055f0 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055bf:	83 c2 01             	add    $0x1,%edx
801055c2:	83 fa 10             	cmp    $0x10,%edx
801055c5:	75 f1                	jne    801055b8 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801055c7:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
801055ce:	00 
    fileclose(rf);
801055cf:	89 1c 24             	mov    %ebx,(%esp)
801055d2:	e8 49 b8 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
801055d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801055da:	89 04 24             	mov    %eax,(%esp)
801055dd:	e8 3e b8 ff ff       	call   80100e20 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801055e2:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801055ea:	5b                   	pop    %ebx
801055eb:	5e                   	pop    %esi
801055ec:	5f                   	pop    %edi
801055ed:	5d                   	pop    %ebp
801055ee:	c3                   	ret    
801055ef:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801055f0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801055f7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801055f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801055ff:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105602:	31 c0                	xor    %eax,%eax
}
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	66 90                	xchg   %ax,%ax
8010560b:	66 90                	xchg   %ax,%ax
8010560d:	66 90                	xchg   %ax,%ax
8010560f:	90                   	nop

80105610 <sys_sysnumcall>:
#include "syscall.h"

int sysCalls[23]; 
int
sys_sysnumcall(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
 cprintf("\nThis system call is implemented by Tanmay Pradhan A20376280");
80105616:	c7 04 24 20 7a 10 80 	movl   $0x80107a20,(%esp)
8010561d:	e8 2e b0 ff ff       	call   80100650 <cprintf>
 cprintf("\nTotal Sys Calls-> %d",sysCalls[0]); 
80105622:	a1 e0 4c 11 80       	mov    0x80114ce0,%eax
80105627:	c7 04 24 5d 7a 10 80 	movl   $0x80107a5d,(%esp)
8010562e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105632:	e8 19 b0 ff ff       	call   80100650 <cprintf>
 cprintf("\nFork Calls-> %d",sysCalls[1]);
80105637:	a1 e4 4c 11 80       	mov    0x80114ce4,%eax
8010563c:	c7 04 24 73 7a 10 80 	movl   $0x80107a73,(%esp)
80105643:	89 44 24 04          	mov    %eax,0x4(%esp)
80105647:	e8 04 b0 ff ff       	call   80100650 <cprintf>
 cprintf("\nExit Call->%d",sysCalls[2]);
8010564c:	a1 e8 4c 11 80       	mov    0x80114ce8,%eax
80105651:	c7 04 24 84 7a 10 80 	movl   $0x80107a84,(%esp)
80105658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565c:	e8 ef af ff ff       	call   80100650 <cprintf>
 cprintf("\nWait Call->%d",sysCalls[3]);
80105661:	a1 ec 4c 11 80       	mov    0x80114cec,%eax
80105666:	c7 04 24 93 7a 10 80 	movl   $0x80107a93,(%esp)
8010566d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105671:	e8 da af ff ff       	call   80100650 <cprintf>
 cprintf("\nPipe Call->%d",sysCalls[4]);
80105676:	a1 f0 4c 11 80       	mov    0x80114cf0,%eax
8010567b:	c7 04 24 a2 7a 10 80 	movl   $0x80107aa2,(%esp)
80105682:	89 44 24 04          	mov    %eax,0x4(%esp)
80105686:	e8 c5 af ff ff       	call   80100650 <cprintf>
 cprintf("\nRead Call->%d",sysCalls[5]);
8010568b:	a1 f4 4c 11 80       	mov    0x80114cf4,%eax
80105690:	c7 04 24 b1 7a 10 80 	movl   $0x80107ab1,(%esp)
80105697:	89 44 24 04          	mov    %eax,0x4(%esp)
8010569b:	e8 b0 af ff ff       	call   80100650 <cprintf>
 cprintf("\nkill Call->%d",sysCalls[6]);
801056a0:	a1 f8 4c 11 80       	mov    0x80114cf8,%eax
801056a5:	c7 04 24 c0 7a 10 80 	movl   $0x80107ac0,(%esp)
801056ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b0:	e8 9b af ff ff       	call   80100650 <cprintf>
 cprintf("\nExec Call->%d",sysCalls[7]);
801056b5:	a1 fc 4c 11 80       	mov    0x80114cfc,%eax
801056ba:	c7 04 24 cf 7a 10 80 	movl   $0x80107acf,(%esp)
801056c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c5:	e8 86 af ff ff       	call   80100650 <cprintf>
 cprintf("\nfstat Call->%d",sysCalls[8]);
801056ca:	a1 00 4d 11 80       	mov    0x80114d00,%eax
801056cf:	c7 04 24 de 7a 10 80 	movl   $0x80107ade,(%esp)
801056d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801056da:	e8 71 af ff ff       	call   80100650 <cprintf>
 cprintf("\nChdir Call->%d",sysCalls[9]);
801056df:	a1 04 4d 11 80       	mov    0x80114d04,%eax
801056e4:	c7 04 24 ee 7a 10 80 	movl   $0x80107aee,(%esp)
801056eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ef:	e8 5c af ff ff       	call   80100650 <cprintf>
 cprintf("\nDup Call->%d",sysCalls[10]);
801056f4:	a1 08 4d 11 80       	mov    0x80114d08,%eax
801056f9:	c7 04 24 fe 7a 10 80 	movl   $0x80107afe,(%esp)
80105700:	89 44 24 04          	mov    %eax,0x4(%esp)
80105704:	e8 47 af ff ff       	call   80100650 <cprintf>
 cprintf("\nGet PID Call->%d",sysCalls[11]);
80105709:	a1 0c 4d 11 80       	mov    0x80114d0c,%eax
8010570e:	c7 04 24 0c 7b 10 80 	movl   $0x80107b0c,(%esp)
80105715:	89 44 24 04          	mov    %eax,0x4(%esp)
80105719:	e8 32 af ff ff       	call   80100650 <cprintf>
 cprintf("\nSbrk Call->%d",sysCalls[12]);
8010571e:	a1 10 4d 11 80       	mov    0x80114d10,%eax
80105723:	c7 04 24 1e 7b 10 80 	movl   $0x80107b1e,(%esp)
8010572a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010572e:	e8 1d af ff ff       	call   80100650 <cprintf>
 cprintf("\nSleep Call->%d",sysCalls[13]);
80105733:	a1 14 4d 11 80       	mov    0x80114d14,%eax
80105738:	c7 04 24 2d 7b 10 80 	movl   $0x80107b2d,(%esp)
8010573f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105743:	e8 08 af ff ff       	call   80100650 <cprintf>
 cprintf("\nUptime Call->%d",sysCalls[14]);
80105748:	a1 18 4d 11 80       	mov    0x80114d18,%eax
8010574d:	c7 04 24 3d 7b 10 80 	movl   $0x80107b3d,(%esp)
80105754:	89 44 24 04          	mov    %eax,0x4(%esp)
80105758:	e8 f3 ae ff ff       	call   80100650 <cprintf>
 cprintf("\nOpen Call->%d",sysCalls[15]);
8010575d:	a1 1c 4d 11 80       	mov    0x80114d1c,%eax
80105762:	c7 04 24 4e 7b 10 80 	movl   $0x80107b4e,(%esp)
80105769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576d:	e8 de ae ff ff       	call   80100650 <cprintf>
 cprintf("\nWrite Call->%d",sysCalls[16]);
80105772:	a1 20 4d 11 80       	mov    0x80114d20,%eax
80105777:	c7 04 24 5d 7b 10 80 	movl   $0x80107b5d,(%esp)
8010577e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105782:	e8 c9 ae ff ff       	call   80100650 <cprintf>
 cprintf("\nMknod Call->%d",sysCalls[17]);
80105787:	a1 24 4d 11 80       	mov    0x80114d24,%eax
8010578c:	c7 04 24 6d 7b 10 80 	movl   $0x80107b6d,(%esp)
80105793:	89 44 24 04          	mov    %eax,0x4(%esp)
80105797:	e8 b4 ae ff ff       	call   80100650 <cprintf>
 cprintf("\nunlink Call->%d",sysCalls[18]);
8010579c:	a1 28 4d 11 80       	mov    0x80114d28,%eax
801057a1:	c7 04 24 7d 7b 10 80 	movl   $0x80107b7d,(%esp)
801057a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ac:	e8 9f ae ff ff       	call   80100650 <cprintf>
 cprintf("\nlink Call->%d",sysCalls[19]);
801057b1:	a1 2c 4d 11 80       	mov    0x80114d2c,%eax
801057b6:	c7 04 24 8e 7b 10 80 	movl   $0x80107b8e,(%esp)
801057bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c1:	e8 8a ae ff ff       	call   80100650 <cprintf>
 cprintf("\nmkdir Call->%d",sysCalls[20]);
801057c6:	a1 30 4d 11 80       	mov    0x80114d30,%eax
801057cb:	c7 04 24 9d 7b 10 80 	movl   $0x80107b9d,(%esp)
801057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801057d6:	e8 75 ae ff ff       	call   80100650 <cprintf>
 cprintf("\nClose Call->%d",sysCalls[21]);
801057db:	a1 34 4d 11 80       	mov    0x80114d34,%eax
801057e0:	c7 04 24 ad 7b 10 80 	movl   $0x80107bad,(%esp)
801057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801057eb:	e8 60 ae ff ff       	call   80100650 <cprintf>
 cprintf("\nSysnumcall Call->%d",sysCalls[22]);
801057f0:	a1 38 4d 11 80       	mov    0x80114d38,%eax
801057f5:	c7 04 24 bd 7b 10 80 	movl   $0x80107bbd,(%esp)
801057fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105800:	e8 4b ae ff ff       	call   80100650 <cprintf>
 memset(sysCalls,0,sizeof(sysCalls));
80105805:	c7 44 24 08 5c 00 00 	movl   $0x5c,0x8(%esp)
8010580c:	00 
8010580d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105814:	00 
80105815:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
8010581c:	e8 2f ec ff ff       	call   80104450 <memset>
return 0; 
 
}
80105821:	31 c0                	xor    %eax,%eax
80105823:	c9                   	leave  
80105824:	c3                   	ret    
80105825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <sys_fork>:
int
sys_fork(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105833:	5d                   	pop    %ebp
 
}
int
sys_fork(void)
{
  return fork();
80105834:	e9 e7 e1 ff ff       	jmp    80103a20 <fork>
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_exit>:
}

int
sys_exit(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 08             	sub    $0x8,%esp
  exit();
80105846:	e8 35 e4 ff ff       	call   80103c80 <exit>
  return 0;  // not reached
}
8010584b:	31 c0                	xor    %eax,%eax
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop

80105850 <sys_wait>:

int
sys_wait(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105853:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105854:	e9 57 e6 ff ff       	jmp    80103eb0 <wait>
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_kill>:
}

int
sys_kill(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105866:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105869:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105874:	e8 a7 ee ff ff       	call   80104720 <argint>
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 13                	js     80105890 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010587d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105880:	89 04 24             	mov    %eax,(%esp)
80105883:	e8 68 e7 ff ff       	call   80103ff0 <kill>
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
801058a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
801058a6:	55                   	push   %ebp
801058a7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
801058a9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
801058aa:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ad:	c3                   	ret    
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
801058b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801058be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058c5:	e8 56 ee ff ff       	call   80104720 <argint>
801058ca:	85 c0                	test   %eax,%eax
801058cc:	78 22                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801058ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801058d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801058d7:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058d9:	89 14 24             	mov    %edx,(%esp)
801058dc:	e8 bf e0 ff ff       	call   801039a0 <growproc>
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 0b                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  return addr;
801058e5:	89 d8                	mov    %ebx,%eax
}
801058e7:	83 c4 24             	add    $0x24,%esp
801058ea:	5b                   	pop    %ebx
801058eb:	5d                   	pop    %ebp
801058ec:	c3                   	ret    
801058ed:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f5:	eb f0                	jmp    801058e7 <sys_sbrk+0x37>
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
80105904:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105907:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010590a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010590e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105915:	e8 06 ee ff ff       	call   80104720 <argint>
8010591a:	85 c0                	test   %eax,%eax
8010591c:	78 7e                	js     8010599c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010591e:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80105925:	e8 a6 e9 ff ff       	call   801042d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010592a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010592d:	8b 1d 80 55 11 80    	mov    0x80115580,%ebx
  while(ticks - ticks0 < n){
80105933:	85 d2                	test   %edx,%edx
80105935:	75 29                	jne    80105960 <sys_sleep+0x60>
80105937:	eb 4f                	jmp    80105988 <sys_sleep+0x88>
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105940:	c7 44 24 04 40 4d 11 	movl   $0x80114d40,0x4(%esp)
80105947:	80 
80105948:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
8010594f:	e8 9c e4 ff ff       	call   80103df0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105954:	a1 80 55 11 80       	mov    0x80115580,%eax
80105959:	29 d8                	sub    %ebx,%eax
8010595b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010595e:	73 28                	jae    80105988 <sys_sleep+0x88>
    if(proc->killed){
80105960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105966:	8b 40 24             	mov    0x24(%eax),%eax
80105969:	85 c0                	test   %eax,%eax
8010596b:	74 d3                	je     80105940 <sys_sleep+0x40>
      release(&tickslock);
8010596d:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80105974:	e8 87 ea ff ff       	call   80104400 <release>
      return -1;
80105979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010597e:	83 c4 24             	add    $0x24,%esp
80105981:	5b                   	pop    %ebx
80105982:	5d                   	pop    %ebp
80105983:	c3                   	ret    
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105988:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010598f:	e8 6c ea ff ff       	call   80104400 <release>
  return 0;
}
80105994:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105997:	31 c0                	xor    %eax,%eax
}
80105999:	5b                   	pop    %ebx
8010599a:	5d                   	pop    %ebp
8010599b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010599c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a1:	eb db                	jmp    8010597e <sys_sleep+0x7e>
801059a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801059b7:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801059be:	e8 0d e9 ff ff       	call   801042d0 <acquire>
  xticks = ticks;
801059c3:	8b 1d 80 55 11 80    	mov    0x80115580,%ebx
  release(&tickslock);
801059c9:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801059d0:	e8 2b ea ff ff       	call   80104400 <release>
  return xticks;
}
801059d5:	83 c4 14             	add    $0x14,%esp
801059d8:	89 d8                	mov    %ebx,%eax
801059da:	5b                   	pop    %ebx
801059db:	5d                   	pop    %ebp
801059dc:	c3                   	ret    
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801059e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801059e1:	ba 43 00 00 00       	mov    $0x43,%edx
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	b8 34 00 00 00       	mov    $0x34,%eax
801059ed:	83 ec 18             	sub    $0x18,%esp
801059f0:	ee                   	out    %al,(%dx)
801059f1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801059f6:	b2 40                	mov    $0x40,%dl
801059f8:	ee                   	out    %al,(%dx)
801059f9:	b8 2e 00 00 00       	mov    $0x2e,%eax
801059fe:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801059ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a06:	e8 05 d9 ff ff       	call   80103310 <picenable>
}
80105a0b:	c9                   	leave  
80105a0c:	c3                   	ret    

80105a0d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a0d:	1e                   	push   %ds
  pushl %es
80105a0e:	06                   	push   %es
  pushl %fs
80105a0f:	0f a0                	push   %fs
  pushl %gs
80105a11:	0f a8                	push   %gs
  pushal
80105a13:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105a14:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a18:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a1a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105a1c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105a20:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105a22:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a24:	54                   	push   %esp
  call trap
80105a25:	e8 e6 00 00 00       	call   80105b10 <trap>
  addl $4, %esp
80105a2a:	83 c4 04             	add    $0x4,%esp

80105a2d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a2d:	61                   	popa   
  popl %gs
80105a2e:	0f a9                	pop    %gs
  popl %fs
80105a30:	0f a1                	pop    %fs
  popl %es
80105a32:	07                   	pop    %es
  popl %ds
80105a33:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a34:	83 c4 08             	add    $0x8,%esp
  iret
80105a37:	cf                   	iret   
80105a38:	66 90                	xchg   %ax,%ax
80105a3a:	66 90                	xchg   %ax,%ax
80105a3c:	66 90                	xchg   %ax,%ax
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a40:	31 c0                	xor    %eax,%eax
80105a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a48:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105a4f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105a54:	66 89 0c c5 82 4d 11 	mov    %cx,-0x7feeb27e(,%eax,8)
80105a5b:	80 
80105a5c:	c6 04 c5 84 4d 11 80 	movb   $0x0,-0x7feeb27c(,%eax,8)
80105a63:	00 
80105a64:	c6 04 c5 85 4d 11 80 	movb   $0x8e,-0x7feeb27b(,%eax,8)
80105a6b:	8e 
80105a6c:	66 89 14 c5 80 4d 11 	mov    %dx,-0x7feeb280(,%eax,8)
80105a73:	80 
80105a74:	c1 ea 10             	shr    $0x10,%edx
80105a77:	66 89 14 c5 86 4d 11 	mov    %dx,-0x7feeb27a(,%eax,8)
80105a7e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a7f:	83 c0 01             	add    $0x1,%eax
80105a82:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a87:	75 bf                	jne    80105a48 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a89:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a8a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a8f:	89 e5                	mov    %esp,%ebp
80105a91:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a94:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105a99:	c7 44 24 04 d2 7b 10 	movl   $0x80107bd2,0x4(%esp)
80105aa0:	80 
80105aa1:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aa8:	66 89 15 82 4f 11 80 	mov    %dx,0x80114f82
80105aaf:	66 a3 80 4f 11 80    	mov    %ax,0x80114f80
80105ab5:	c1 e8 10             	shr    $0x10,%eax
80105ab8:	c6 05 84 4f 11 80 00 	movb   $0x0,0x80114f84
80105abf:	c6 05 85 4f 11 80 ef 	movb   $0xef,0x80114f85
80105ac6:	66 a3 86 4f 11 80    	mov    %ax,0x80114f86

  initlock(&tickslock, "time");
80105acc:	e8 7f e7 ff ff       	call   80104250 <initlock>
}
80105ad1:	c9                   	leave  
80105ad2:	c3                   	ret    
80105ad3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ae0 <idtinit>:

void
idtinit(void)
{
80105ae0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105ae1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ae6:	89 e5                	mov    %esp,%ebp
80105ae8:	83 ec 10             	sub    $0x10,%esp
80105aeb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105aef:	b8 80 4d 11 80       	mov    $0x80114d80,%eax
80105af4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105af8:	c1 e8 10             	shr    $0x10,%eax
80105afb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105aff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
80105b16:	83 ec 2c             	sub    $0x2c,%esp
80105b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b1f:	83 f8 40             	cmp    $0x40,%eax
80105b22:	0f 84 00 01 00 00    	je     80105c28 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b28:	83 e8 20             	sub    $0x20,%eax
80105b2b:	83 f8 1f             	cmp    $0x1f,%eax
80105b2e:	77 60                	ja     80105b90 <trap+0x80>
80105b30:	ff 24 85 78 7c 10 80 	jmp    *-0x7fef8388(,%eax,4)
80105b37:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105b38:	e8 33 cd ff ff       	call   80102870 <cpunum>
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	90                   	nop
80105b40:	0f 84 d2 01 00 00    	je     80105d18 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105b46:	e8 c5 cd ff ff       	call   80102910 <lapiceoi>
80105b4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b51:	85 c0                	test   %eax,%eax
80105b53:	74 2d                	je     80105b82 <trap+0x72>
80105b55:	8b 50 24             	mov    0x24(%eax),%edx
80105b58:	85 d2                	test   %edx,%edx
80105b5a:	0f 85 9c 00 00 00    	jne    80105bfc <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105b60:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b64:	0f 84 86 01 00 00    	je     80105cf0 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b6a:	8b 40 24             	mov    0x24(%eax),%eax
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	74 11                	je     80105b82 <trap+0x72>
80105b71:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b75:	83 e0 03             	and    $0x3,%eax
80105b78:	66 83 f8 03          	cmp    $0x3,%ax
80105b7c:	0f 84 d0 00 00 00    	je     80105c52 <trap+0x142>
    exit();
}
80105b82:	83 c4 2c             	add    $0x2c,%esp
80105b85:	5b                   	pop    %ebx
80105b86:	5e                   	pop    %esi
80105b87:	5f                   	pop    %edi
80105b88:	5d                   	pop    %ebp
80105b89:	c3                   	ret    
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105b90:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105b97:	85 c9                	test   %ecx,%ecx
80105b99:	0f 84 a9 01 00 00    	je     80105d48 <trap+0x238>
80105b9f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ba3:	0f 84 9f 01 00 00    	je     80105d48 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ba9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bac:	8b 73 38             	mov    0x38(%ebx),%esi
80105baf:	e8 bc cc ff ff       	call   80102870 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105bb4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bbb:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
80105bbf:	89 74 24 18          	mov    %esi,0x18(%esp)
80105bc3:	89 44 24 14          	mov    %eax,0x14(%esp)
80105bc7:	8b 43 34             	mov    0x34(%ebx),%eax
80105bca:	89 44 24 10          	mov    %eax,0x10(%esp)
80105bce:	8b 43 30             	mov    0x30(%ebx),%eax
80105bd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105bd5:	8d 42 6c             	lea    0x6c(%edx),%eax
80105bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bdc:	8b 42 10             	mov    0x10(%edx),%eax
80105bdf:	c7 04 24 34 7c 10 80 	movl   $0x80107c34,(%esp)
80105be6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bea:	e8 61 aa ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105bef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bf5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105bfc:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105c00:	83 e2 03             	and    $0x3,%edx
80105c03:	66 83 fa 03          	cmp    $0x3,%dx
80105c07:	0f 85 53 ff ff ff    	jne    80105b60 <trap+0x50>
    exit();
80105c0d:	e8 6e e0 ff ff       	call   80103c80 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105c12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	0f 85 40 ff ff ff    	jne    80105b60 <trap+0x50>
80105c20:	e9 5d ff ff ff       	jmp    80105b82 <trap+0x72>
80105c25:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105c28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c2e:	8b 70 24             	mov    0x24(%eax),%esi
80105c31:	85 f6                	test   %esi,%esi
80105c33:	0f 85 a7 00 00 00    	jne    80105ce0 <trap+0x1d0>
      exit();
    proc->tf = tf;
80105c39:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c3c:	e8 ef eb ff ff       	call   80104830 <syscall>
    if(proc->killed)
80105c41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c47:	8b 58 24             	mov    0x24(%eax),%ebx
80105c4a:	85 db                	test   %ebx,%ebx
80105c4c:	0f 84 30 ff ff ff    	je     80105b82 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105c52:	83 c4 2c             	add    $0x2c,%esp
80105c55:	5b                   	pop    %ebx
80105c56:	5e                   	pop    %esi
80105c57:	5f                   	pop    %edi
80105c58:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105c59:	e9 22 e0 ff ff       	jmp    80103c80 <exit>
80105c5e:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105c60:	e8 7b ca ff ff       	call   801026e0 <kbdintr>
    lapiceoi();
80105c65:	e8 a6 cc ff ff       	call   80102910 <lapiceoi>
80105c6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105c70:	e9 dc fe ff ff       	jmp    80105b51 <trap+0x41>
80105c75:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c78:	e8 13 c5 ff ff       	call   80102190 <ideintr>
    lapiceoi();
80105c7d:	e8 8e cc ff ff       	call   80102910 <lapiceoi>
80105c82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105c88:	e9 c4 fe ff ff       	jmp    80105b51 <trap+0x41>
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105c90:	e8 1b 02 00 00       	call   80105eb0 <uartintr>
    lapiceoi();
80105c95:	e8 76 cc ff ff       	call   80102910 <lapiceoi>
80105c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105ca0:	e9 ac fe ff ff       	jmp    80105b51 <trap+0x41>
80105ca5:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ca8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105caf:	e8 bc cb ff ff       	call   80102870 <cpunum>
80105cb4:	c7 04 24 dc 7b 10 80 	movl   $0x80107bdc,(%esp)
80105cbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105cbf:	89 74 24 08          	mov    %esi,0x8(%esp)
80105cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc7:	e8 84 a9 ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105ccc:	e8 3f cc ff ff       	call   80102910 <lapiceoi>
80105cd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105cd7:	e9 75 fe ff ff       	jmp    80105b51 <trap+0x41>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105ce0:	e8 9b df ff ff       	call   80103c80 <exit>
80105ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ceb:	e9 49 ff ff ff       	jmp    80105c39 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105cf0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cf4:	0f 85 70 fe ff ff    	jne    80105b6a <trap+0x5a>
    yield();
80105cfa:	e8 b1 e0 ff ff       	call   80103db0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105cff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d05:	85 c0                	test   %eax,%eax
80105d07:	0f 85 5d fe ff ff    	jne    80105b6a <trap+0x5a>
80105d0d:	e9 70 fe ff ff       	jmp    80105b82 <trap+0x72>
80105d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105d18:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80105d1f:	e8 ac e5 ff ff       	call   801042d0 <acquire>
      ticks++;
      wakeup(&ticks);
80105d24:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105d2b:	83 05 80 55 11 80 01 	addl   $0x1,0x80115580
      wakeup(&ticks);
80105d32:	e8 59 e2 ff ff       	call   80103f90 <wakeup>
      release(&tickslock);
80105d37:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80105d3e:	e8 bd e6 ff ff       	call   80104400 <release>
80105d43:	e9 fe fd ff ff       	jmp    80105b46 <trap+0x36>
80105d48:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d4b:	8b 73 38             	mov    0x38(%ebx),%esi
80105d4e:	e8 1d cb ff ff       	call   80102870 <cpunum>
80105d53:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105d57:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105d5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d5f:	8b 43 30             	mov    0x30(%ebx),%eax
80105d62:	c7 04 24 00 7c 10 80 	movl   $0x80107c00,(%esp)
80105d69:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6d:	e8 de a8 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105d72:	c7 04 24 d7 7b 10 80 	movl   $0x80107bd7,(%esp)
80105d79:	e8 e2 a5 ff ff       	call   80100360 <panic>
80105d7e:	66 90                	xchg   %ax,%ax

80105d80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d80:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105d85:	55                   	push   %ebp
80105d86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	74 14                	je     80105da0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d92:	a8 01                	test   $0x1,%al
80105d94:	74 0a                	je     80105da0 <uartgetc+0x20>
80105d96:	b2 f8                	mov    $0xf8,%dl
80105d98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d99:	0f b6 c0             	movzbl %al,%eax
}
80105d9c:	5d                   	pop    %ebp
80105d9d:	c3                   	ret    
80105d9e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105da5:	5d                   	pop    %ebp
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105db0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	74 3f                	je     80105df8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105db9:	55                   	push   %ebp
80105dba:	89 e5                	mov    %esp,%ebp
80105dbc:	56                   	push   %esi
80105dbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dc2:	53                   	push   %ebx
  int i;

  if(!uart)
80105dc3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105dc8:	83 ec 10             	sub    $0x10,%esp
80105dcb:	eb 14                	jmp    80105de1 <uartputc+0x31>
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105dd0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105dd7:	e8 54 cb ff ff       	call   80102930 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ddc:	83 eb 01             	sub    $0x1,%ebx
80105ddf:	74 07                	je     80105de8 <uartputc+0x38>
80105de1:	89 f2                	mov    %esi,%edx
80105de3:	ec                   	in     (%dx),%al
80105de4:	a8 20                	test   $0x20,%al
80105de6:	74 e8                	je     80105dd0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105de8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dec:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105df1:	ee                   	out    %al,(%dx)
}
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	5b                   	pop    %ebx
80105df6:	5e                   	pop    %esi
80105df7:	5d                   	pop    %ebp
80105df8:	f3 c3                	repz ret 
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105e00:	55                   	push   %ebp
80105e01:	31 c9                	xor    %ecx,%ecx
80105e03:	89 e5                	mov    %esp,%ebp
80105e05:	89 c8                	mov    %ecx,%eax
80105e07:	57                   	push   %edi
80105e08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e0d:	56                   	push   %esi
80105e0e:	89 fa                	mov    %edi,%edx
80105e10:	53                   	push   %ebx
80105e11:	83 ec 1c             	sub    $0x1c,%esp
80105e14:	ee                   	out    %al,(%dx)
80105e15:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e1f:	89 f2                	mov    %esi,%edx
80105e21:	ee                   	out    %al,(%dx)
80105e22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e27:	b2 f8                	mov    $0xf8,%dl
80105e29:	ee                   	out    %al,(%dx)
80105e2a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e2f:	89 c8                	mov    %ecx,%eax
80105e31:	89 da                	mov    %ebx,%edx
80105e33:	ee                   	out    %al,(%dx)
80105e34:	b8 03 00 00 00       	mov    $0x3,%eax
80105e39:	89 f2                	mov    %esi,%edx
80105e3b:	ee                   	out    %al,(%dx)
80105e3c:	b2 fc                	mov    $0xfc,%dl
80105e3e:	89 c8                	mov    %ecx,%eax
80105e40:	ee                   	out    %al,(%dx)
80105e41:	b8 01 00 00 00       	mov    $0x1,%eax
80105e46:	89 da                	mov    %ebx,%edx
80105e48:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e49:	b2 fd                	mov    $0xfd,%dl
80105e4b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105e4c:	3c ff                	cmp    $0xff,%al
80105e4e:	74 52                	je     80105ea2 <uartinit+0xa2>
    return;
  uart = 1;
80105e50:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105e57:	00 00 00 
80105e5a:	89 fa                	mov    %edi,%edx
80105e5c:	ec                   	in     (%dx),%al
80105e5d:	b2 f8                	mov    $0xf8,%dl
80105e5f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105e60:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e67:	bb f8 7c 10 80       	mov    $0x80107cf8,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105e6c:	e8 9f d4 ff ff       	call   80103310 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105e71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e78:	00 
80105e79:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105e80:	e8 3b c5 ff ff       	call   801023c0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e85:	b8 78 00 00 00       	mov    $0x78,%eax
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105e90:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e93:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105e96:	e8 15 ff ff ff       	call   80105db0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e9b:	0f be 03             	movsbl (%ebx),%eax
80105e9e:	84 c0                	test   %al,%al
80105ea0:	75 ee                	jne    80105e90 <uartinit+0x90>
    uartputc(*p);
}
80105ea2:	83 c4 1c             	add    $0x1c,%esp
80105ea5:	5b                   	pop    %ebx
80105ea6:	5e                   	pop    %esi
80105ea7:	5f                   	pop    %edi
80105ea8:	5d                   	pop    %ebp
80105ea9:	c3                   	ret    
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105eb0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105eb6:	c7 04 24 80 5d 10 80 	movl   $0x80105d80,(%esp)
80105ebd:	e8 ee a8 ff ff       	call   801007b0 <consoleintr>
}
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    

80105ec4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $0
80105ec6:	6a 00                	push   $0x0
  jmp alltraps
80105ec8:	e9 40 fb ff ff       	jmp    80105a0d <alltraps>

80105ecd <vector1>:
.globl vector1
vector1:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $1
80105ecf:	6a 01                	push   $0x1
  jmp alltraps
80105ed1:	e9 37 fb ff ff       	jmp    80105a0d <alltraps>

80105ed6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $2
80105ed8:	6a 02                	push   $0x2
  jmp alltraps
80105eda:	e9 2e fb ff ff       	jmp    80105a0d <alltraps>

80105edf <vector3>:
.globl vector3
vector3:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $3
80105ee1:	6a 03                	push   $0x3
  jmp alltraps
80105ee3:	e9 25 fb ff ff       	jmp    80105a0d <alltraps>

80105ee8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $4
80105eea:	6a 04                	push   $0x4
  jmp alltraps
80105eec:	e9 1c fb ff ff       	jmp    80105a0d <alltraps>

80105ef1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $5
80105ef3:	6a 05                	push   $0x5
  jmp alltraps
80105ef5:	e9 13 fb ff ff       	jmp    80105a0d <alltraps>

80105efa <vector6>:
.globl vector6
vector6:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $6
80105efc:	6a 06                	push   $0x6
  jmp alltraps
80105efe:	e9 0a fb ff ff       	jmp    80105a0d <alltraps>

80105f03 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $7
80105f05:	6a 07                	push   $0x7
  jmp alltraps
80105f07:	e9 01 fb ff ff       	jmp    80105a0d <alltraps>

80105f0c <vector8>:
.globl vector8
vector8:
  pushl $8
80105f0c:	6a 08                	push   $0x8
  jmp alltraps
80105f0e:	e9 fa fa ff ff       	jmp    80105a0d <alltraps>

80105f13 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $9
80105f15:	6a 09                	push   $0x9
  jmp alltraps
80105f17:	e9 f1 fa ff ff       	jmp    80105a0d <alltraps>

80105f1c <vector10>:
.globl vector10
vector10:
  pushl $10
80105f1c:	6a 0a                	push   $0xa
  jmp alltraps
80105f1e:	e9 ea fa ff ff       	jmp    80105a0d <alltraps>

80105f23 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f23:	6a 0b                	push   $0xb
  jmp alltraps
80105f25:	e9 e3 fa ff ff       	jmp    80105a0d <alltraps>

80105f2a <vector12>:
.globl vector12
vector12:
  pushl $12
80105f2a:	6a 0c                	push   $0xc
  jmp alltraps
80105f2c:	e9 dc fa ff ff       	jmp    80105a0d <alltraps>

80105f31 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f31:	6a 0d                	push   $0xd
  jmp alltraps
80105f33:	e9 d5 fa ff ff       	jmp    80105a0d <alltraps>

80105f38 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f38:	6a 0e                	push   $0xe
  jmp alltraps
80105f3a:	e9 ce fa ff ff       	jmp    80105a0d <alltraps>

80105f3f <vector15>:
.globl vector15
vector15:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $15
80105f41:	6a 0f                	push   $0xf
  jmp alltraps
80105f43:	e9 c5 fa ff ff       	jmp    80105a0d <alltraps>

80105f48 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $16
80105f4a:	6a 10                	push   $0x10
  jmp alltraps
80105f4c:	e9 bc fa ff ff       	jmp    80105a0d <alltraps>

80105f51 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f51:	6a 11                	push   $0x11
  jmp alltraps
80105f53:	e9 b5 fa ff ff       	jmp    80105a0d <alltraps>

80105f58 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $18
80105f5a:	6a 12                	push   $0x12
  jmp alltraps
80105f5c:	e9 ac fa ff ff       	jmp    80105a0d <alltraps>

80105f61 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $19
80105f63:	6a 13                	push   $0x13
  jmp alltraps
80105f65:	e9 a3 fa ff ff       	jmp    80105a0d <alltraps>

80105f6a <vector20>:
.globl vector20
vector20:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $20
80105f6c:	6a 14                	push   $0x14
  jmp alltraps
80105f6e:	e9 9a fa ff ff       	jmp    80105a0d <alltraps>

80105f73 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $21
80105f75:	6a 15                	push   $0x15
  jmp alltraps
80105f77:	e9 91 fa ff ff       	jmp    80105a0d <alltraps>

80105f7c <vector22>:
.globl vector22
vector22:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $22
80105f7e:	6a 16                	push   $0x16
  jmp alltraps
80105f80:	e9 88 fa ff ff       	jmp    80105a0d <alltraps>

80105f85 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $23
80105f87:	6a 17                	push   $0x17
  jmp alltraps
80105f89:	e9 7f fa ff ff       	jmp    80105a0d <alltraps>

80105f8e <vector24>:
.globl vector24
vector24:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $24
80105f90:	6a 18                	push   $0x18
  jmp alltraps
80105f92:	e9 76 fa ff ff       	jmp    80105a0d <alltraps>

80105f97 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $25
80105f99:	6a 19                	push   $0x19
  jmp alltraps
80105f9b:	e9 6d fa ff ff       	jmp    80105a0d <alltraps>

80105fa0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $26
80105fa2:	6a 1a                	push   $0x1a
  jmp alltraps
80105fa4:	e9 64 fa ff ff       	jmp    80105a0d <alltraps>

80105fa9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $27
80105fab:	6a 1b                	push   $0x1b
  jmp alltraps
80105fad:	e9 5b fa ff ff       	jmp    80105a0d <alltraps>

80105fb2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $28
80105fb4:	6a 1c                	push   $0x1c
  jmp alltraps
80105fb6:	e9 52 fa ff ff       	jmp    80105a0d <alltraps>

80105fbb <vector29>:
.globl vector29
vector29:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $29
80105fbd:	6a 1d                	push   $0x1d
  jmp alltraps
80105fbf:	e9 49 fa ff ff       	jmp    80105a0d <alltraps>

80105fc4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $30
80105fc6:	6a 1e                	push   $0x1e
  jmp alltraps
80105fc8:	e9 40 fa ff ff       	jmp    80105a0d <alltraps>

80105fcd <vector31>:
.globl vector31
vector31:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $31
80105fcf:	6a 1f                	push   $0x1f
  jmp alltraps
80105fd1:	e9 37 fa ff ff       	jmp    80105a0d <alltraps>

80105fd6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $32
80105fd8:	6a 20                	push   $0x20
  jmp alltraps
80105fda:	e9 2e fa ff ff       	jmp    80105a0d <alltraps>

80105fdf <vector33>:
.globl vector33
vector33:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $33
80105fe1:	6a 21                	push   $0x21
  jmp alltraps
80105fe3:	e9 25 fa ff ff       	jmp    80105a0d <alltraps>

80105fe8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $34
80105fea:	6a 22                	push   $0x22
  jmp alltraps
80105fec:	e9 1c fa ff ff       	jmp    80105a0d <alltraps>

80105ff1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $35
80105ff3:	6a 23                	push   $0x23
  jmp alltraps
80105ff5:	e9 13 fa ff ff       	jmp    80105a0d <alltraps>

80105ffa <vector36>:
.globl vector36
vector36:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $36
80105ffc:	6a 24                	push   $0x24
  jmp alltraps
80105ffe:	e9 0a fa ff ff       	jmp    80105a0d <alltraps>

80106003 <vector37>:
.globl vector37
vector37:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $37
80106005:	6a 25                	push   $0x25
  jmp alltraps
80106007:	e9 01 fa ff ff       	jmp    80105a0d <alltraps>

8010600c <vector38>:
.globl vector38
vector38:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $38
8010600e:	6a 26                	push   $0x26
  jmp alltraps
80106010:	e9 f8 f9 ff ff       	jmp    80105a0d <alltraps>

80106015 <vector39>:
.globl vector39
vector39:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $39
80106017:	6a 27                	push   $0x27
  jmp alltraps
80106019:	e9 ef f9 ff ff       	jmp    80105a0d <alltraps>

8010601e <vector40>:
.globl vector40
vector40:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $40
80106020:	6a 28                	push   $0x28
  jmp alltraps
80106022:	e9 e6 f9 ff ff       	jmp    80105a0d <alltraps>

80106027 <vector41>:
.globl vector41
vector41:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $41
80106029:	6a 29                	push   $0x29
  jmp alltraps
8010602b:	e9 dd f9 ff ff       	jmp    80105a0d <alltraps>

80106030 <vector42>:
.globl vector42
vector42:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $42
80106032:	6a 2a                	push   $0x2a
  jmp alltraps
80106034:	e9 d4 f9 ff ff       	jmp    80105a0d <alltraps>

80106039 <vector43>:
.globl vector43
vector43:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $43
8010603b:	6a 2b                	push   $0x2b
  jmp alltraps
8010603d:	e9 cb f9 ff ff       	jmp    80105a0d <alltraps>

80106042 <vector44>:
.globl vector44
vector44:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $44
80106044:	6a 2c                	push   $0x2c
  jmp alltraps
80106046:	e9 c2 f9 ff ff       	jmp    80105a0d <alltraps>

8010604b <vector45>:
.globl vector45
vector45:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $45
8010604d:	6a 2d                	push   $0x2d
  jmp alltraps
8010604f:	e9 b9 f9 ff ff       	jmp    80105a0d <alltraps>

80106054 <vector46>:
.globl vector46
vector46:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $46
80106056:	6a 2e                	push   $0x2e
  jmp alltraps
80106058:	e9 b0 f9 ff ff       	jmp    80105a0d <alltraps>

8010605d <vector47>:
.globl vector47
vector47:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $47
8010605f:	6a 2f                	push   $0x2f
  jmp alltraps
80106061:	e9 a7 f9 ff ff       	jmp    80105a0d <alltraps>

80106066 <vector48>:
.globl vector48
vector48:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $48
80106068:	6a 30                	push   $0x30
  jmp alltraps
8010606a:	e9 9e f9 ff ff       	jmp    80105a0d <alltraps>

8010606f <vector49>:
.globl vector49
vector49:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $49
80106071:	6a 31                	push   $0x31
  jmp alltraps
80106073:	e9 95 f9 ff ff       	jmp    80105a0d <alltraps>

80106078 <vector50>:
.globl vector50
vector50:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $50
8010607a:	6a 32                	push   $0x32
  jmp alltraps
8010607c:	e9 8c f9 ff ff       	jmp    80105a0d <alltraps>

80106081 <vector51>:
.globl vector51
vector51:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $51
80106083:	6a 33                	push   $0x33
  jmp alltraps
80106085:	e9 83 f9 ff ff       	jmp    80105a0d <alltraps>

8010608a <vector52>:
.globl vector52
vector52:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $52
8010608c:	6a 34                	push   $0x34
  jmp alltraps
8010608e:	e9 7a f9 ff ff       	jmp    80105a0d <alltraps>

80106093 <vector53>:
.globl vector53
vector53:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $53
80106095:	6a 35                	push   $0x35
  jmp alltraps
80106097:	e9 71 f9 ff ff       	jmp    80105a0d <alltraps>

8010609c <vector54>:
.globl vector54
vector54:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $54
8010609e:	6a 36                	push   $0x36
  jmp alltraps
801060a0:	e9 68 f9 ff ff       	jmp    80105a0d <alltraps>

801060a5 <vector55>:
.globl vector55
vector55:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $55
801060a7:	6a 37                	push   $0x37
  jmp alltraps
801060a9:	e9 5f f9 ff ff       	jmp    80105a0d <alltraps>

801060ae <vector56>:
.globl vector56
vector56:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $56
801060b0:	6a 38                	push   $0x38
  jmp alltraps
801060b2:	e9 56 f9 ff ff       	jmp    80105a0d <alltraps>

801060b7 <vector57>:
.globl vector57
vector57:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $57
801060b9:	6a 39                	push   $0x39
  jmp alltraps
801060bb:	e9 4d f9 ff ff       	jmp    80105a0d <alltraps>

801060c0 <vector58>:
.globl vector58
vector58:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $58
801060c2:	6a 3a                	push   $0x3a
  jmp alltraps
801060c4:	e9 44 f9 ff ff       	jmp    80105a0d <alltraps>

801060c9 <vector59>:
.globl vector59
vector59:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $59
801060cb:	6a 3b                	push   $0x3b
  jmp alltraps
801060cd:	e9 3b f9 ff ff       	jmp    80105a0d <alltraps>

801060d2 <vector60>:
.globl vector60
vector60:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $60
801060d4:	6a 3c                	push   $0x3c
  jmp alltraps
801060d6:	e9 32 f9 ff ff       	jmp    80105a0d <alltraps>

801060db <vector61>:
.globl vector61
vector61:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $61
801060dd:	6a 3d                	push   $0x3d
  jmp alltraps
801060df:	e9 29 f9 ff ff       	jmp    80105a0d <alltraps>

801060e4 <vector62>:
.globl vector62
vector62:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $62
801060e6:	6a 3e                	push   $0x3e
  jmp alltraps
801060e8:	e9 20 f9 ff ff       	jmp    80105a0d <alltraps>

801060ed <vector63>:
.globl vector63
vector63:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $63
801060ef:	6a 3f                	push   $0x3f
  jmp alltraps
801060f1:	e9 17 f9 ff ff       	jmp    80105a0d <alltraps>

801060f6 <vector64>:
.globl vector64
vector64:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $64
801060f8:	6a 40                	push   $0x40
  jmp alltraps
801060fa:	e9 0e f9 ff ff       	jmp    80105a0d <alltraps>

801060ff <vector65>:
.globl vector65
vector65:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $65
80106101:	6a 41                	push   $0x41
  jmp alltraps
80106103:	e9 05 f9 ff ff       	jmp    80105a0d <alltraps>

80106108 <vector66>:
.globl vector66
vector66:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $66
8010610a:	6a 42                	push   $0x42
  jmp alltraps
8010610c:	e9 fc f8 ff ff       	jmp    80105a0d <alltraps>

80106111 <vector67>:
.globl vector67
vector67:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $67
80106113:	6a 43                	push   $0x43
  jmp alltraps
80106115:	e9 f3 f8 ff ff       	jmp    80105a0d <alltraps>

8010611a <vector68>:
.globl vector68
vector68:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $68
8010611c:	6a 44                	push   $0x44
  jmp alltraps
8010611e:	e9 ea f8 ff ff       	jmp    80105a0d <alltraps>

80106123 <vector69>:
.globl vector69
vector69:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $69
80106125:	6a 45                	push   $0x45
  jmp alltraps
80106127:	e9 e1 f8 ff ff       	jmp    80105a0d <alltraps>

8010612c <vector70>:
.globl vector70
vector70:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $70
8010612e:	6a 46                	push   $0x46
  jmp alltraps
80106130:	e9 d8 f8 ff ff       	jmp    80105a0d <alltraps>

80106135 <vector71>:
.globl vector71
vector71:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $71
80106137:	6a 47                	push   $0x47
  jmp alltraps
80106139:	e9 cf f8 ff ff       	jmp    80105a0d <alltraps>

8010613e <vector72>:
.globl vector72
vector72:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $72
80106140:	6a 48                	push   $0x48
  jmp alltraps
80106142:	e9 c6 f8 ff ff       	jmp    80105a0d <alltraps>

80106147 <vector73>:
.globl vector73
vector73:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $73
80106149:	6a 49                	push   $0x49
  jmp alltraps
8010614b:	e9 bd f8 ff ff       	jmp    80105a0d <alltraps>

80106150 <vector74>:
.globl vector74
vector74:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $74
80106152:	6a 4a                	push   $0x4a
  jmp alltraps
80106154:	e9 b4 f8 ff ff       	jmp    80105a0d <alltraps>

80106159 <vector75>:
.globl vector75
vector75:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $75
8010615b:	6a 4b                	push   $0x4b
  jmp alltraps
8010615d:	e9 ab f8 ff ff       	jmp    80105a0d <alltraps>

80106162 <vector76>:
.globl vector76
vector76:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $76
80106164:	6a 4c                	push   $0x4c
  jmp alltraps
80106166:	e9 a2 f8 ff ff       	jmp    80105a0d <alltraps>

8010616b <vector77>:
.globl vector77
vector77:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $77
8010616d:	6a 4d                	push   $0x4d
  jmp alltraps
8010616f:	e9 99 f8 ff ff       	jmp    80105a0d <alltraps>

80106174 <vector78>:
.globl vector78
vector78:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $78
80106176:	6a 4e                	push   $0x4e
  jmp alltraps
80106178:	e9 90 f8 ff ff       	jmp    80105a0d <alltraps>

8010617d <vector79>:
.globl vector79
vector79:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $79
8010617f:	6a 4f                	push   $0x4f
  jmp alltraps
80106181:	e9 87 f8 ff ff       	jmp    80105a0d <alltraps>

80106186 <vector80>:
.globl vector80
vector80:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $80
80106188:	6a 50                	push   $0x50
  jmp alltraps
8010618a:	e9 7e f8 ff ff       	jmp    80105a0d <alltraps>

8010618f <vector81>:
.globl vector81
vector81:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $81
80106191:	6a 51                	push   $0x51
  jmp alltraps
80106193:	e9 75 f8 ff ff       	jmp    80105a0d <alltraps>

80106198 <vector82>:
.globl vector82
vector82:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $82
8010619a:	6a 52                	push   $0x52
  jmp alltraps
8010619c:	e9 6c f8 ff ff       	jmp    80105a0d <alltraps>

801061a1 <vector83>:
.globl vector83
vector83:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $83
801061a3:	6a 53                	push   $0x53
  jmp alltraps
801061a5:	e9 63 f8 ff ff       	jmp    80105a0d <alltraps>

801061aa <vector84>:
.globl vector84
vector84:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $84
801061ac:	6a 54                	push   $0x54
  jmp alltraps
801061ae:	e9 5a f8 ff ff       	jmp    80105a0d <alltraps>

801061b3 <vector85>:
.globl vector85
vector85:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $85
801061b5:	6a 55                	push   $0x55
  jmp alltraps
801061b7:	e9 51 f8 ff ff       	jmp    80105a0d <alltraps>

801061bc <vector86>:
.globl vector86
vector86:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $86
801061be:	6a 56                	push   $0x56
  jmp alltraps
801061c0:	e9 48 f8 ff ff       	jmp    80105a0d <alltraps>

801061c5 <vector87>:
.globl vector87
vector87:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $87
801061c7:	6a 57                	push   $0x57
  jmp alltraps
801061c9:	e9 3f f8 ff ff       	jmp    80105a0d <alltraps>

801061ce <vector88>:
.globl vector88
vector88:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $88
801061d0:	6a 58                	push   $0x58
  jmp alltraps
801061d2:	e9 36 f8 ff ff       	jmp    80105a0d <alltraps>

801061d7 <vector89>:
.globl vector89
vector89:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $89
801061d9:	6a 59                	push   $0x59
  jmp alltraps
801061db:	e9 2d f8 ff ff       	jmp    80105a0d <alltraps>

801061e0 <vector90>:
.globl vector90
vector90:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $90
801061e2:	6a 5a                	push   $0x5a
  jmp alltraps
801061e4:	e9 24 f8 ff ff       	jmp    80105a0d <alltraps>

801061e9 <vector91>:
.globl vector91
vector91:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $91
801061eb:	6a 5b                	push   $0x5b
  jmp alltraps
801061ed:	e9 1b f8 ff ff       	jmp    80105a0d <alltraps>

801061f2 <vector92>:
.globl vector92
vector92:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $92
801061f4:	6a 5c                	push   $0x5c
  jmp alltraps
801061f6:	e9 12 f8 ff ff       	jmp    80105a0d <alltraps>

801061fb <vector93>:
.globl vector93
vector93:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $93
801061fd:	6a 5d                	push   $0x5d
  jmp alltraps
801061ff:	e9 09 f8 ff ff       	jmp    80105a0d <alltraps>

80106204 <vector94>:
.globl vector94
vector94:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $94
80106206:	6a 5e                	push   $0x5e
  jmp alltraps
80106208:	e9 00 f8 ff ff       	jmp    80105a0d <alltraps>

8010620d <vector95>:
.globl vector95
vector95:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $95
8010620f:	6a 5f                	push   $0x5f
  jmp alltraps
80106211:	e9 f7 f7 ff ff       	jmp    80105a0d <alltraps>

80106216 <vector96>:
.globl vector96
vector96:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $96
80106218:	6a 60                	push   $0x60
  jmp alltraps
8010621a:	e9 ee f7 ff ff       	jmp    80105a0d <alltraps>

8010621f <vector97>:
.globl vector97
vector97:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $97
80106221:	6a 61                	push   $0x61
  jmp alltraps
80106223:	e9 e5 f7 ff ff       	jmp    80105a0d <alltraps>

80106228 <vector98>:
.globl vector98
vector98:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $98
8010622a:	6a 62                	push   $0x62
  jmp alltraps
8010622c:	e9 dc f7 ff ff       	jmp    80105a0d <alltraps>

80106231 <vector99>:
.globl vector99
vector99:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $99
80106233:	6a 63                	push   $0x63
  jmp alltraps
80106235:	e9 d3 f7 ff ff       	jmp    80105a0d <alltraps>

8010623a <vector100>:
.globl vector100
vector100:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $100
8010623c:	6a 64                	push   $0x64
  jmp alltraps
8010623e:	e9 ca f7 ff ff       	jmp    80105a0d <alltraps>

80106243 <vector101>:
.globl vector101
vector101:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $101
80106245:	6a 65                	push   $0x65
  jmp alltraps
80106247:	e9 c1 f7 ff ff       	jmp    80105a0d <alltraps>

8010624c <vector102>:
.globl vector102
vector102:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $102
8010624e:	6a 66                	push   $0x66
  jmp alltraps
80106250:	e9 b8 f7 ff ff       	jmp    80105a0d <alltraps>

80106255 <vector103>:
.globl vector103
vector103:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $103
80106257:	6a 67                	push   $0x67
  jmp alltraps
80106259:	e9 af f7 ff ff       	jmp    80105a0d <alltraps>

8010625e <vector104>:
.globl vector104
vector104:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $104
80106260:	6a 68                	push   $0x68
  jmp alltraps
80106262:	e9 a6 f7 ff ff       	jmp    80105a0d <alltraps>

80106267 <vector105>:
.globl vector105
vector105:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $105
80106269:	6a 69                	push   $0x69
  jmp alltraps
8010626b:	e9 9d f7 ff ff       	jmp    80105a0d <alltraps>

80106270 <vector106>:
.globl vector106
vector106:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $106
80106272:	6a 6a                	push   $0x6a
  jmp alltraps
80106274:	e9 94 f7 ff ff       	jmp    80105a0d <alltraps>

80106279 <vector107>:
.globl vector107
vector107:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $107
8010627b:	6a 6b                	push   $0x6b
  jmp alltraps
8010627d:	e9 8b f7 ff ff       	jmp    80105a0d <alltraps>

80106282 <vector108>:
.globl vector108
vector108:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $108
80106284:	6a 6c                	push   $0x6c
  jmp alltraps
80106286:	e9 82 f7 ff ff       	jmp    80105a0d <alltraps>

8010628b <vector109>:
.globl vector109
vector109:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $109
8010628d:	6a 6d                	push   $0x6d
  jmp alltraps
8010628f:	e9 79 f7 ff ff       	jmp    80105a0d <alltraps>

80106294 <vector110>:
.globl vector110
vector110:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $110
80106296:	6a 6e                	push   $0x6e
  jmp alltraps
80106298:	e9 70 f7 ff ff       	jmp    80105a0d <alltraps>

8010629d <vector111>:
.globl vector111
vector111:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $111
8010629f:	6a 6f                	push   $0x6f
  jmp alltraps
801062a1:	e9 67 f7 ff ff       	jmp    80105a0d <alltraps>

801062a6 <vector112>:
.globl vector112
vector112:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $112
801062a8:	6a 70                	push   $0x70
  jmp alltraps
801062aa:	e9 5e f7 ff ff       	jmp    80105a0d <alltraps>

801062af <vector113>:
.globl vector113
vector113:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $113
801062b1:	6a 71                	push   $0x71
  jmp alltraps
801062b3:	e9 55 f7 ff ff       	jmp    80105a0d <alltraps>

801062b8 <vector114>:
.globl vector114
vector114:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $114
801062ba:	6a 72                	push   $0x72
  jmp alltraps
801062bc:	e9 4c f7 ff ff       	jmp    80105a0d <alltraps>

801062c1 <vector115>:
.globl vector115
vector115:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $115
801062c3:	6a 73                	push   $0x73
  jmp alltraps
801062c5:	e9 43 f7 ff ff       	jmp    80105a0d <alltraps>

801062ca <vector116>:
.globl vector116
vector116:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $116
801062cc:	6a 74                	push   $0x74
  jmp alltraps
801062ce:	e9 3a f7 ff ff       	jmp    80105a0d <alltraps>

801062d3 <vector117>:
.globl vector117
vector117:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $117
801062d5:	6a 75                	push   $0x75
  jmp alltraps
801062d7:	e9 31 f7 ff ff       	jmp    80105a0d <alltraps>

801062dc <vector118>:
.globl vector118
vector118:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $118
801062de:	6a 76                	push   $0x76
  jmp alltraps
801062e0:	e9 28 f7 ff ff       	jmp    80105a0d <alltraps>

801062e5 <vector119>:
.globl vector119
vector119:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $119
801062e7:	6a 77                	push   $0x77
  jmp alltraps
801062e9:	e9 1f f7 ff ff       	jmp    80105a0d <alltraps>

801062ee <vector120>:
.globl vector120
vector120:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $120
801062f0:	6a 78                	push   $0x78
  jmp alltraps
801062f2:	e9 16 f7 ff ff       	jmp    80105a0d <alltraps>

801062f7 <vector121>:
.globl vector121
vector121:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $121
801062f9:	6a 79                	push   $0x79
  jmp alltraps
801062fb:	e9 0d f7 ff ff       	jmp    80105a0d <alltraps>

80106300 <vector122>:
.globl vector122
vector122:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $122
80106302:	6a 7a                	push   $0x7a
  jmp alltraps
80106304:	e9 04 f7 ff ff       	jmp    80105a0d <alltraps>

80106309 <vector123>:
.globl vector123
vector123:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $123
8010630b:	6a 7b                	push   $0x7b
  jmp alltraps
8010630d:	e9 fb f6 ff ff       	jmp    80105a0d <alltraps>

80106312 <vector124>:
.globl vector124
vector124:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $124
80106314:	6a 7c                	push   $0x7c
  jmp alltraps
80106316:	e9 f2 f6 ff ff       	jmp    80105a0d <alltraps>

8010631b <vector125>:
.globl vector125
vector125:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $125
8010631d:	6a 7d                	push   $0x7d
  jmp alltraps
8010631f:	e9 e9 f6 ff ff       	jmp    80105a0d <alltraps>

80106324 <vector126>:
.globl vector126
vector126:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $126
80106326:	6a 7e                	push   $0x7e
  jmp alltraps
80106328:	e9 e0 f6 ff ff       	jmp    80105a0d <alltraps>

8010632d <vector127>:
.globl vector127
vector127:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $127
8010632f:	6a 7f                	push   $0x7f
  jmp alltraps
80106331:	e9 d7 f6 ff ff       	jmp    80105a0d <alltraps>

80106336 <vector128>:
.globl vector128
vector128:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $128
80106338:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010633d:	e9 cb f6 ff ff       	jmp    80105a0d <alltraps>

80106342 <vector129>:
.globl vector129
vector129:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $129
80106344:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106349:	e9 bf f6 ff ff       	jmp    80105a0d <alltraps>

8010634e <vector130>:
.globl vector130
vector130:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $130
80106350:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106355:	e9 b3 f6 ff ff       	jmp    80105a0d <alltraps>

8010635a <vector131>:
.globl vector131
vector131:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $131
8010635c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106361:	e9 a7 f6 ff ff       	jmp    80105a0d <alltraps>

80106366 <vector132>:
.globl vector132
vector132:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $132
80106368:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010636d:	e9 9b f6 ff ff       	jmp    80105a0d <alltraps>

80106372 <vector133>:
.globl vector133
vector133:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $133
80106374:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106379:	e9 8f f6 ff ff       	jmp    80105a0d <alltraps>

8010637e <vector134>:
.globl vector134
vector134:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $134
80106380:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106385:	e9 83 f6 ff ff       	jmp    80105a0d <alltraps>

8010638a <vector135>:
.globl vector135
vector135:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $135
8010638c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106391:	e9 77 f6 ff ff       	jmp    80105a0d <alltraps>

80106396 <vector136>:
.globl vector136
vector136:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $136
80106398:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010639d:	e9 6b f6 ff ff       	jmp    80105a0d <alltraps>

801063a2 <vector137>:
.globl vector137
vector137:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $137
801063a4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063a9:	e9 5f f6 ff ff       	jmp    80105a0d <alltraps>

801063ae <vector138>:
.globl vector138
vector138:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $138
801063b0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063b5:	e9 53 f6 ff ff       	jmp    80105a0d <alltraps>

801063ba <vector139>:
.globl vector139
vector139:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $139
801063bc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063c1:	e9 47 f6 ff ff       	jmp    80105a0d <alltraps>

801063c6 <vector140>:
.globl vector140
vector140:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $140
801063c8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063cd:	e9 3b f6 ff ff       	jmp    80105a0d <alltraps>

801063d2 <vector141>:
.globl vector141
vector141:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $141
801063d4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063d9:	e9 2f f6 ff ff       	jmp    80105a0d <alltraps>

801063de <vector142>:
.globl vector142
vector142:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $142
801063e0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063e5:	e9 23 f6 ff ff       	jmp    80105a0d <alltraps>

801063ea <vector143>:
.globl vector143
vector143:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $143
801063ec:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063f1:	e9 17 f6 ff ff       	jmp    80105a0d <alltraps>

801063f6 <vector144>:
.globl vector144
vector144:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $144
801063f8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063fd:	e9 0b f6 ff ff       	jmp    80105a0d <alltraps>

80106402 <vector145>:
.globl vector145
vector145:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $145
80106404:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106409:	e9 ff f5 ff ff       	jmp    80105a0d <alltraps>

8010640e <vector146>:
.globl vector146
vector146:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $146
80106410:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106415:	e9 f3 f5 ff ff       	jmp    80105a0d <alltraps>

8010641a <vector147>:
.globl vector147
vector147:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $147
8010641c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106421:	e9 e7 f5 ff ff       	jmp    80105a0d <alltraps>

80106426 <vector148>:
.globl vector148
vector148:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $148
80106428:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010642d:	e9 db f5 ff ff       	jmp    80105a0d <alltraps>

80106432 <vector149>:
.globl vector149
vector149:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $149
80106434:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106439:	e9 cf f5 ff ff       	jmp    80105a0d <alltraps>

8010643e <vector150>:
.globl vector150
vector150:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $150
80106440:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106445:	e9 c3 f5 ff ff       	jmp    80105a0d <alltraps>

8010644a <vector151>:
.globl vector151
vector151:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $151
8010644c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106451:	e9 b7 f5 ff ff       	jmp    80105a0d <alltraps>

80106456 <vector152>:
.globl vector152
vector152:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $152
80106458:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010645d:	e9 ab f5 ff ff       	jmp    80105a0d <alltraps>

80106462 <vector153>:
.globl vector153
vector153:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $153
80106464:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106469:	e9 9f f5 ff ff       	jmp    80105a0d <alltraps>

8010646e <vector154>:
.globl vector154
vector154:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $154
80106470:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106475:	e9 93 f5 ff ff       	jmp    80105a0d <alltraps>

8010647a <vector155>:
.globl vector155
vector155:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $155
8010647c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106481:	e9 87 f5 ff ff       	jmp    80105a0d <alltraps>

80106486 <vector156>:
.globl vector156
vector156:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $156
80106488:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010648d:	e9 7b f5 ff ff       	jmp    80105a0d <alltraps>

80106492 <vector157>:
.globl vector157
vector157:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $157
80106494:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106499:	e9 6f f5 ff ff       	jmp    80105a0d <alltraps>

8010649e <vector158>:
.globl vector158
vector158:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $158
801064a0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064a5:	e9 63 f5 ff ff       	jmp    80105a0d <alltraps>

801064aa <vector159>:
.globl vector159
vector159:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $159
801064ac:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064b1:	e9 57 f5 ff ff       	jmp    80105a0d <alltraps>

801064b6 <vector160>:
.globl vector160
vector160:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $160
801064b8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064bd:	e9 4b f5 ff ff       	jmp    80105a0d <alltraps>

801064c2 <vector161>:
.globl vector161
vector161:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $161
801064c4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064c9:	e9 3f f5 ff ff       	jmp    80105a0d <alltraps>

801064ce <vector162>:
.globl vector162
vector162:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $162
801064d0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064d5:	e9 33 f5 ff ff       	jmp    80105a0d <alltraps>

801064da <vector163>:
.globl vector163
vector163:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $163
801064dc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064e1:	e9 27 f5 ff ff       	jmp    80105a0d <alltraps>

801064e6 <vector164>:
.globl vector164
vector164:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $164
801064e8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064ed:	e9 1b f5 ff ff       	jmp    80105a0d <alltraps>

801064f2 <vector165>:
.globl vector165
vector165:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $165
801064f4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064f9:	e9 0f f5 ff ff       	jmp    80105a0d <alltraps>

801064fe <vector166>:
.globl vector166
vector166:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $166
80106500:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106505:	e9 03 f5 ff ff       	jmp    80105a0d <alltraps>

8010650a <vector167>:
.globl vector167
vector167:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $167
8010650c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106511:	e9 f7 f4 ff ff       	jmp    80105a0d <alltraps>

80106516 <vector168>:
.globl vector168
vector168:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $168
80106518:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010651d:	e9 eb f4 ff ff       	jmp    80105a0d <alltraps>

80106522 <vector169>:
.globl vector169
vector169:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $169
80106524:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106529:	e9 df f4 ff ff       	jmp    80105a0d <alltraps>

8010652e <vector170>:
.globl vector170
vector170:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $170
80106530:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106535:	e9 d3 f4 ff ff       	jmp    80105a0d <alltraps>

8010653a <vector171>:
.globl vector171
vector171:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $171
8010653c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106541:	e9 c7 f4 ff ff       	jmp    80105a0d <alltraps>

80106546 <vector172>:
.globl vector172
vector172:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $172
80106548:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010654d:	e9 bb f4 ff ff       	jmp    80105a0d <alltraps>

80106552 <vector173>:
.globl vector173
vector173:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $173
80106554:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106559:	e9 af f4 ff ff       	jmp    80105a0d <alltraps>

8010655e <vector174>:
.globl vector174
vector174:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $174
80106560:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106565:	e9 a3 f4 ff ff       	jmp    80105a0d <alltraps>

8010656a <vector175>:
.globl vector175
vector175:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $175
8010656c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106571:	e9 97 f4 ff ff       	jmp    80105a0d <alltraps>

80106576 <vector176>:
.globl vector176
vector176:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $176
80106578:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010657d:	e9 8b f4 ff ff       	jmp    80105a0d <alltraps>

80106582 <vector177>:
.globl vector177
vector177:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $177
80106584:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106589:	e9 7f f4 ff ff       	jmp    80105a0d <alltraps>

8010658e <vector178>:
.globl vector178
vector178:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $178
80106590:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106595:	e9 73 f4 ff ff       	jmp    80105a0d <alltraps>

8010659a <vector179>:
.globl vector179
vector179:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $179
8010659c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065a1:	e9 67 f4 ff ff       	jmp    80105a0d <alltraps>

801065a6 <vector180>:
.globl vector180
vector180:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $180
801065a8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065ad:	e9 5b f4 ff ff       	jmp    80105a0d <alltraps>

801065b2 <vector181>:
.globl vector181
vector181:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $181
801065b4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065b9:	e9 4f f4 ff ff       	jmp    80105a0d <alltraps>

801065be <vector182>:
.globl vector182
vector182:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $182
801065c0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065c5:	e9 43 f4 ff ff       	jmp    80105a0d <alltraps>

801065ca <vector183>:
.globl vector183
vector183:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $183
801065cc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065d1:	e9 37 f4 ff ff       	jmp    80105a0d <alltraps>

801065d6 <vector184>:
.globl vector184
vector184:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $184
801065d8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065dd:	e9 2b f4 ff ff       	jmp    80105a0d <alltraps>

801065e2 <vector185>:
.globl vector185
vector185:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $185
801065e4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065e9:	e9 1f f4 ff ff       	jmp    80105a0d <alltraps>

801065ee <vector186>:
.globl vector186
vector186:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $186
801065f0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065f5:	e9 13 f4 ff ff       	jmp    80105a0d <alltraps>

801065fa <vector187>:
.globl vector187
vector187:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $187
801065fc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106601:	e9 07 f4 ff ff       	jmp    80105a0d <alltraps>

80106606 <vector188>:
.globl vector188
vector188:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $188
80106608:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010660d:	e9 fb f3 ff ff       	jmp    80105a0d <alltraps>

80106612 <vector189>:
.globl vector189
vector189:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $189
80106614:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106619:	e9 ef f3 ff ff       	jmp    80105a0d <alltraps>

8010661e <vector190>:
.globl vector190
vector190:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $190
80106620:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106625:	e9 e3 f3 ff ff       	jmp    80105a0d <alltraps>

8010662a <vector191>:
.globl vector191
vector191:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $191
8010662c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106631:	e9 d7 f3 ff ff       	jmp    80105a0d <alltraps>

80106636 <vector192>:
.globl vector192
vector192:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $192
80106638:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010663d:	e9 cb f3 ff ff       	jmp    80105a0d <alltraps>

80106642 <vector193>:
.globl vector193
vector193:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $193
80106644:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106649:	e9 bf f3 ff ff       	jmp    80105a0d <alltraps>

8010664e <vector194>:
.globl vector194
vector194:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $194
80106650:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106655:	e9 b3 f3 ff ff       	jmp    80105a0d <alltraps>

8010665a <vector195>:
.globl vector195
vector195:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $195
8010665c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106661:	e9 a7 f3 ff ff       	jmp    80105a0d <alltraps>

80106666 <vector196>:
.globl vector196
vector196:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $196
80106668:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010666d:	e9 9b f3 ff ff       	jmp    80105a0d <alltraps>

80106672 <vector197>:
.globl vector197
vector197:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $197
80106674:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106679:	e9 8f f3 ff ff       	jmp    80105a0d <alltraps>

8010667e <vector198>:
.globl vector198
vector198:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $198
80106680:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106685:	e9 83 f3 ff ff       	jmp    80105a0d <alltraps>

8010668a <vector199>:
.globl vector199
vector199:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $199
8010668c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106691:	e9 77 f3 ff ff       	jmp    80105a0d <alltraps>

80106696 <vector200>:
.globl vector200
vector200:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $200
80106698:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010669d:	e9 6b f3 ff ff       	jmp    80105a0d <alltraps>

801066a2 <vector201>:
.globl vector201
vector201:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $201
801066a4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066a9:	e9 5f f3 ff ff       	jmp    80105a0d <alltraps>

801066ae <vector202>:
.globl vector202
vector202:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $202
801066b0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066b5:	e9 53 f3 ff ff       	jmp    80105a0d <alltraps>

801066ba <vector203>:
.globl vector203
vector203:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $203
801066bc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066c1:	e9 47 f3 ff ff       	jmp    80105a0d <alltraps>

801066c6 <vector204>:
.globl vector204
vector204:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $204
801066c8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066cd:	e9 3b f3 ff ff       	jmp    80105a0d <alltraps>

801066d2 <vector205>:
.globl vector205
vector205:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $205
801066d4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066d9:	e9 2f f3 ff ff       	jmp    80105a0d <alltraps>

801066de <vector206>:
.globl vector206
vector206:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $206
801066e0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066e5:	e9 23 f3 ff ff       	jmp    80105a0d <alltraps>

801066ea <vector207>:
.globl vector207
vector207:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $207
801066ec:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066f1:	e9 17 f3 ff ff       	jmp    80105a0d <alltraps>

801066f6 <vector208>:
.globl vector208
vector208:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $208
801066f8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066fd:	e9 0b f3 ff ff       	jmp    80105a0d <alltraps>

80106702 <vector209>:
.globl vector209
vector209:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $209
80106704:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106709:	e9 ff f2 ff ff       	jmp    80105a0d <alltraps>

8010670e <vector210>:
.globl vector210
vector210:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $210
80106710:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106715:	e9 f3 f2 ff ff       	jmp    80105a0d <alltraps>

8010671a <vector211>:
.globl vector211
vector211:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $211
8010671c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106721:	e9 e7 f2 ff ff       	jmp    80105a0d <alltraps>

80106726 <vector212>:
.globl vector212
vector212:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $212
80106728:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010672d:	e9 db f2 ff ff       	jmp    80105a0d <alltraps>

80106732 <vector213>:
.globl vector213
vector213:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $213
80106734:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106739:	e9 cf f2 ff ff       	jmp    80105a0d <alltraps>

8010673e <vector214>:
.globl vector214
vector214:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $214
80106740:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106745:	e9 c3 f2 ff ff       	jmp    80105a0d <alltraps>

8010674a <vector215>:
.globl vector215
vector215:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $215
8010674c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106751:	e9 b7 f2 ff ff       	jmp    80105a0d <alltraps>

80106756 <vector216>:
.globl vector216
vector216:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $216
80106758:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010675d:	e9 ab f2 ff ff       	jmp    80105a0d <alltraps>

80106762 <vector217>:
.globl vector217
vector217:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $217
80106764:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106769:	e9 9f f2 ff ff       	jmp    80105a0d <alltraps>

8010676e <vector218>:
.globl vector218
vector218:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $218
80106770:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106775:	e9 93 f2 ff ff       	jmp    80105a0d <alltraps>

8010677a <vector219>:
.globl vector219
vector219:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $219
8010677c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106781:	e9 87 f2 ff ff       	jmp    80105a0d <alltraps>

80106786 <vector220>:
.globl vector220
vector220:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $220
80106788:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010678d:	e9 7b f2 ff ff       	jmp    80105a0d <alltraps>

80106792 <vector221>:
.globl vector221
vector221:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $221
80106794:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106799:	e9 6f f2 ff ff       	jmp    80105a0d <alltraps>

8010679e <vector222>:
.globl vector222
vector222:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $222
801067a0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067a5:	e9 63 f2 ff ff       	jmp    80105a0d <alltraps>

801067aa <vector223>:
.globl vector223
vector223:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $223
801067ac:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067b1:	e9 57 f2 ff ff       	jmp    80105a0d <alltraps>

801067b6 <vector224>:
.globl vector224
vector224:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $224
801067b8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067bd:	e9 4b f2 ff ff       	jmp    80105a0d <alltraps>

801067c2 <vector225>:
.globl vector225
vector225:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $225
801067c4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067c9:	e9 3f f2 ff ff       	jmp    80105a0d <alltraps>

801067ce <vector226>:
.globl vector226
vector226:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $226
801067d0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067d5:	e9 33 f2 ff ff       	jmp    80105a0d <alltraps>

801067da <vector227>:
.globl vector227
vector227:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $227
801067dc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067e1:	e9 27 f2 ff ff       	jmp    80105a0d <alltraps>

801067e6 <vector228>:
.globl vector228
vector228:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $228
801067e8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067ed:	e9 1b f2 ff ff       	jmp    80105a0d <alltraps>

801067f2 <vector229>:
.globl vector229
vector229:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $229
801067f4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067f9:	e9 0f f2 ff ff       	jmp    80105a0d <alltraps>

801067fe <vector230>:
.globl vector230
vector230:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $230
80106800:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106805:	e9 03 f2 ff ff       	jmp    80105a0d <alltraps>

8010680a <vector231>:
.globl vector231
vector231:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $231
8010680c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106811:	e9 f7 f1 ff ff       	jmp    80105a0d <alltraps>

80106816 <vector232>:
.globl vector232
vector232:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $232
80106818:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010681d:	e9 eb f1 ff ff       	jmp    80105a0d <alltraps>

80106822 <vector233>:
.globl vector233
vector233:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $233
80106824:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106829:	e9 df f1 ff ff       	jmp    80105a0d <alltraps>

8010682e <vector234>:
.globl vector234
vector234:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $234
80106830:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106835:	e9 d3 f1 ff ff       	jmp    80105a0d <alltraps>

8010683a <vector235>:
.globl vector235
vector235:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $235
8010683c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106841:	e9 c7 f1 ff ff       	jmp    80105a0d <alltraps>

80106846 <vector236>:
.globl vector236
vector236:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $236
80106848:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010684d:	e9 bb f1 ff ff       	jmp    80105a0d <alltraps>

80106852 <vector237>:
.globl vector237
vector237:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $237
80106854:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106859:	e9 af f1 ff ff       	jmp    80105a0d <alltraps>

8010685e <vector238>:
.globl vector238
vector238:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $238
80106860:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106865:	e9 a3 f1 ff ff       	jmp    80105a0d <alltraps>

8010686a <vector239>:
.globl vector239
vector239:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $239
8010686c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106871:	e9 97 f1 ff ff       	jmp    80105a0d <alltraps>

80106876 <vector240>:
.globl vector240
vector240:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $240
80106878:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010687d:	e9 8b f1 ff ff       	jmp    80105a0d <alltraps>

80106882 <vector241>:
.globl vector241
vector241:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $241
80106884:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106889:	e9 7f f1 ff ff       	jmp    80105a0d <alltraps>

8010688e <vector242>:
.globl vector242
vector242:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $242
80106890:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106895:	e9 73 f1 ff ff       	jmp    80105a0d <alltraps>

8010689a <vector243>:
.globl vector243
vector243:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $243
8010689c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068a1:	e9 67 f1 ff ff       	jmp    80105a0d <alltraps>

801068a6 <vector244>:
.globl vector244
vector244:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $244
801068a8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068ad:	e9 5b f1 ff ff       	jmp    80105a0d <alltraps>

801068b2 <vector245>:
.globl vector245
vector245:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $245
801068b4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068b9:	e9 4f f1 ff ff       	jmp    80105a0d <alltraps>

801068be <vector246>:
.globl vector246
vector246:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $246
801068c0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068c5:	e9 43 f1 ff ff       	jmp    80105a0d <alltraps>

801068ca <vector247>:
.globl vector247
vector247:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $247
801068cc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068d1:	e9 37 f1 ff ff       	jmp    80105a0d <alltraps>

801068d6 <vector248>:
.globl vector248
vector248:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $248
801068d8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068dd:	e9 2b f1 ff ff       	jmp    80105a0d <alltraps>

801068e2 <vector249>:
.globl vector249
vector249:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $249
801068e4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068e9:	e9 1f f1 ff ff       	jmp    80105a0d <alltraps>

801068ee <vector250>:
.globl vector250
vector250:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $250
801068f0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068f5:	e9 13 f1 ff ff       	jmp    80105a0d <alltraps>

801068fa <vector251>:
.globl vector251
vector251:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $251
801068fc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106901:	e9 07 f1 ff ff       	jmp    80105a0d <alltraps>

80106906 <vector252>:
.globl vector252
vector252:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $252
80106908:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010690d:	e9 fb f0 ff ff       	jmp    80105a0d <alltraps>

80106912 <vector253>:
.globl vector253
vector253:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $253
80106914:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106919:	e9 ef f0 ff ff       	jmp    80105a0d <alltraps>

8010691e <vector254>:
.globl vector254
vector254:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $254
80106920:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106925:	e9 e3 f0 ff ff       	jmp    80105a0d <alltraps>

8010692a <vector255>:
.globl vector255
vector255:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $255
8010692c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106931:	e9 d7 f0 ff ff       	jmp    80105a0d <alltraps>
80106936:	66 90                	xchg   %ax,%ax
80106938:	66 90                	xchg   %ax,%ax
8010693a:	66 90                	xchg   %ax,%ax
8010693c:	66 90                	xchg   %ax,%ax
8010693e:	66 90                	xchg   %ax,%ax

80106940 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106947:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010694a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010694b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010694e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106951:	8b 1f                	mov    (%edi),%ebx
80106953:	f6 c3 01             	test   $0x1,%bl
80106956:	74 28                	je     80106980 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106958:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010695e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106964:	c1 ee 0a             	shr    $0xa,%esi
}
80106967:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010696a:	89 f2                	mov    %esi,%edx
8010696c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106972:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106975:	5b                   	pop    %ebx
80106976:	5e                   	pop    %esi
80106977:	5f                   	pop    %edi
80106978:	5d                   	pop    %ebp
80106979:	c3                   	ret    
8010697a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106980:	85 c9                	test   %ecx,%ecx
80106982:	74 34                	je     801069b8 <walkpgdir+0x78>
80106984:	e8 27 bc ff ff       	call   801025b0 <kalloc>
80106989:	85 c0                	test   %eax,%eax
8010698b:	89 c3                	mov    %eax,%ebx
8010698d:	74 29                	je     801069b8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010698f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106996:	00 
80106997:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010699e:	00 
8010699f:	89 04 24             	mov    %eax,(%esp)
801069a2:	e8 a9 da ff ff       	call   80104450 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069a7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069ad:	83 c8 07             	or     $0x7,%eax
801069b0:	89 07                	mov    %eax,(%edi)
801069b2:	eb b0                	jmp    80106964 <walkpgdir+0x24>
801069b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801069b8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801069bb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801069bd:	5b                   	pop    %ebx
801069be:	5e                   	pop    %esi
801069bf:	5f                   	pop    %edi
801069c0:	5d                   	pop    %ebp
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069d6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069d8:	83 ec 1c             	sub    $0x1c,%esp
801069db:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069e7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801069ee:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069f2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801069f9:	29 df                	sub    %ebx,%edi
801069fb:	eb 18                	jmp    80106a15 <mappages+0x45>
801069fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106a00:	f6 00 01             	testb  $0x1,(%eax)
80106a03:	75 3d                	jne    80106a42 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a05:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106a08:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a0b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a0d:	74 29                	je     80106a38 <mappages+0x68>
      break;
    a += PGSIZE;
80106a0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a18:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a1d:	89 da                	mov    %ebx,%edx
80106a1f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a22:	e8 19 ff ff ff       	call   80106940 <walkpgdir>
80106a27:	85 c0                	test   %eax,%eax
80106a29:	75 d5                	jne    80106a00 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106a2b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106a33:	5b                   	pop    %ebx
80106a34:	5e                   	pop    %esi
80106a35:	5f                   	pop    %edi
80106a36:	5d                   	pop    %ebp
80106a37:	c3                   	ret    
80106a38:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106a3b:	31 c0                	xor    %eax,%eax
}
80106a3d:	5b                   	pop    %ebx
80106a3e:	5e                   	pop    %esi
80106a3f:	5f                   	pop    %edi
80106a40:	5d                   	pop    %ebp
80106a41:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106a42:	c7 04 24 00 7d 10 80 	movl   $0x80107d00,(%esp)
80106a49:	e8 12 99 ff ff       	call   80100360 <panic>
80106a4e:	66 90                	xchg   %ax,%ax

80106a50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	89 c7                	mov    %eax,%edi
80106a56:	56                   	push   %esi
80106a57:	89 d6                	mov    %edx,%esi
80106a59:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a5a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a60:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a63:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a69:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a6b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a6e:	72 3b                	jb     80106aab <deallocuvm.part.0+0x5b>
80106a70:	eb 5e                	jmp    80106ad0 <deallocuvm.part.0+0x80>
80106a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a78:	8b 10                	mov    (%eax),%edx
80106a7a:	f6 c2 01             	test   $0x1,%dl
80106a7d:	74 22                	je     80106aa1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a7f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a85:	74 54                	je     80106adb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106a87:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a8d:	89 14 24             	mov    %edx,(%esp)
80106a90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a93:	e8 68 b9 ff ff       	call   80102400 <kfree>
      *pte = 0;
80106a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106aa1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aa7:	39 f3                	cmp    %esi,%ebx
80106aa9:	73 25                	jae    80106ad0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106aab:	31 c9                	xor    %ecx,%ecx
80106aad:	89 da                	mov    %ebx,%edx
80106aaf:	89 f8                	mov    %edi,%eax
80106ab1:	e8 8a fe ff ff       	call   80106940 <walkpgdir>
    if(!pte)
80106ab6:	85 c0                	test   %eax,%eax
80106ab8:	75 be                	jne    80106a78 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106aba:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ac0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106ac6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106acc:	39 f3                	cmp    %esi,%ebx
80106ace:	72 db                	jb     80106aab <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ad3:	83 c4 1c             	add    $0x1c,%esp
80106ad6:	5b                   	pop    %ebx
80106ad7:	5e                   	pop    %esi
80106ad8:	5f                   	pop    %edi
80106ad9:	5d                   	pop    %ebp
80106ada:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106adb:	c7 04 24 12 75 10 80 	movl   $0x80107512,(%esp)
80106ae2:	e8 79 98 ff ff       	call   80100360 <panic>
80106ae7:	89 f6                	mov    %esi,%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106af6:	e8 75 bd ff ff       	call   80102870 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106afb:	31 c9                	xor    %ecx,%ecx
80106afd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106b02:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106b08:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b0d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b11:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b16:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b1a:	31 c9                	xor    %ecx,%ecx
80106b1c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b23:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b28:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b2f:	31 c9                	xor    %ecx,%ecx
80106b31:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b38:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b3d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b44:	31 c9                	xor    %ecx,%ecx
80106b46:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b4d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b53:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b5a:	31 c9                	xor    %ecx,%ecx
80106b5c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80106b63:	89 d1                	mov    %edx,%ecx
80106b65:	c1 e9 10             	shr    $0x10,%ecx
80106b68:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
80106b6f:	c1 ea 18             	shr    $0x18,%edx
80106b72:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106b78:	b9 37 00 00 00       	mov    $0x37,%ecx
80106b7d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106b83:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b86:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80106b8a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b8e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106b95:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b9c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106ba3:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106baa:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106bb1:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106bb8:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80106bbf:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106bc6:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106bca:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bce:	c1 ea 10             	shr    $0x10,%edx
80106bd1:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106bd5:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bd8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106bdc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106be0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106be7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bee:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106bf5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bfc:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106c03:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80106c0a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106c0d:	ba 18 00 00 00       	mov    $0x18,%edx
80106c12:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106c14:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106c1b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
80106c1f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106c25:	c9                   	leave  
80106c26:	c3                   	ret    
80106c27:	89 f6                	mov    %esi,%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c30 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	56                   	push   %esi
80106c34:	53                   	push   %ebx
80106c35:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106c38:	e8 73 b9 ff ff       	call   801025b0 <kalloc>
80106c3d:	85 c0                	test   %eax,%eax
80106c3f:	89 c6                	mov    %eax,%esi
80106c41:	74 55                	je     80106c98 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c4a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c4b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c57:	00 
80106c58:	89 04 24             	mov    %eax,(%esp)
80106c5b:	e8 f0 d7 ff ff       	call   80104450 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106c60:	8b 53 0c             	mov    0xc(%ebx),%edx
80106c63:	8b 43 04             	mov    0x4(%ebx),%eax
80106c66:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106c69:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c6d:	8b 13                	mov    (%ebx),%edx
80106c6f:	89 04 24             	mov    %eax,(%esp)
80106c72:	29 c1                	sub    %eax,%ecx
80106c74:	89 f0                	mov    %esi,%eax
80106c76:	e8 55 fd ff ff       	call   801069d0 <mappages>
80106c7b:	85 c0                	test   %eax,%eax
80106c7d:	78 19                	js     80106c98 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c7f:	83 c3 10             	add    $0x10,%ebx
80106c82:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c88:	72 d6                	jb     80106c60 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c8a:	83 c4 10             	add    $0x10,%esp
80106c8d:	89 f0                	mov    %esi,%eax
80106c8f:	5b                   	pop    %ebx
80106c90:	5e                   	pop    %esi
80106c91:	5d                   	pop    %ebp
80106c92:	c3                   	ret    
80106c93:	90                   	nop
80106c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c98:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106c9b:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c9d:	5b                   	pop    %ebx
80106c9e:	5e                   	pop    %esi
80106c9f:	5d                   	pop    %ebp
80106ca0:	c3                   	ret    
80106ca1:	eb 0d                	jmp    80106cb0 <kvmalloc>
80106ca3:	90                   	nop
80106ca4:	90                   	nop
80106ca5:	90                   	nop
80106ca6:	90                   	nop
80106ca7:	90                   	nop
80106ca8:	90                   	nop
80106ca9:	90                   	nop
80106caa:	90                   	nop
80106cab:	90                   	nop
80106cac:	90                   	nop
80106cad:	90                   	nop
80106cae:	90                   	nop
80106caf:	90                   	nop

80106cb0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106cb6:	e8 75 ff ff ff       	call   80106c30 <setupkvm>
80106cbb:	a3 84 55 11 80       	mov    %eax,0x80115584
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cc0:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cc5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106cc8:	c9                   	leave  
80106cc9:	c3                   	ret    
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cd0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cd0:	a1 84 55 11 80       	mov    0x80115584,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106cd5:	55                   	push   %ebp
80106cd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cd8:	05 00 00 00 80       	add    $0x80000000,%eax
80106cdd:	0f 22 d8             	mov    %eax,%cr3
}
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret    
80106ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	53                   	push   %ebx
80106cf4:	83 ec 14             	sub    $0x14,%esp
80106cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106cfa:	85 db                	test   %ebx,%ebx
80106cfc:	0f 84 94 00 00 00    	je     80106d96 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106d02:	8b 43 08             	mov    0x8(%ebx),%eax
80106d05:	85 c0                	test   %eax,%eax
80106d07:	0f 84 a1 00 00 00    	je     80106dae <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106d0d:	8b 43 04             	mov    0x4(%ebx),%eax
80106d10:	85 c0                	test   %eax,%eax
80106d12:	0f 84 8a 00 00 00    	je     80106da2 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106d18:	e8 63 d6 ff ff       	call   80104380 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106d1d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d23:	b9 67 00 00 00       	mov    $0x67,%ecx
80106d28:	8d 50 08             	lea    0x8(%eax),%edx
80106d2b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106d32:	89 d1                	mov    %edx,%ecx
80106d34:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106d3b:	c1 ea 18             	shr    $0x18,%edx
80106d3e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106d44:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106d47:	ba 10 00 00 00       	mov    $0x10,%edx
80106d4c:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106d50:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80106d56:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106d5d:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d64:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d67:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106d6d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d72:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106d75:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106d79:	b8 30 00 00 00       	mov    $0x30,%eax
80106d7e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d81:	8b 43 04             	mov    0x4(%ebx),%eax
80106d84:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d89:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106d8c:	83 c4 14             	add    $0x14,%esp
80106d8f:	5b                   	pop    %ebx
80106d90:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106d91:	e9 1a d6 ff ff       	jmp    801043b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106d96:	c7 04 24 06 7d 10 80 	movl   $0x80107d06,(%esp)
80106d9d:	e8 be 95 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106da2:	c7 04 24 31 7d 10 80 	movl   $0x80107d31,(%esp)
80106da9:	e8 b2 95 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106dae:	c7 04 24 1c 7d 10 80 	movl   $0x80107d1c,(%esp)
80106db5:	e8 a6 95 ff ff       	call   80100360 <panic>
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dc0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
80106dc6:	83 ec 1c             	sub    $0x1c,%esp
80106dc9:	8b 75 10             	mov    0x10(%ebp),%esi
80106dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106dd2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106ddb:	77 54                	ja     80106e31 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80106ddd:	e8 ce b7 ff ff       	call   801025b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106de2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106de9:	00 
80106dea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106df1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106df2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106df4:	89 04 24             	mov    %eax,(%esp)
80106df7:	e8 54 d6 ff ff       	call   80104450 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106dfc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e07:	89 04 24             	mov    %eax,(%esp)
80106e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e0d:	31 d2                	xor    %edx,%edx
80106e0f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106e16:	00 
80106e17:	e8 b4 fb ff ff       	call   801069d0 <mappages>
  memmove(mem, init, sz);
80106e1c:	89 75 10             	mov    %esi,0x10(%ebp)
80106e1f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e22:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e25:	83 c4 1c             	add    $0x1c,%esp
80106e28:	5b                   	pop    %ebx
80106e29:	5e                   	pop    %esi
80106e2a:	5f                   	pop    %edi
80106e2b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106e2c:	e9 bf d6 ff ff       	jmp    801044f0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106e31:	c7 04 24 45 7d 10 80 	movl   $0x80107d45,(%esp)
80106e38:	e8 23 95 ff ff       	call   80100360 <panic>
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi

80106e40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106e49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e50:	0f 85 98 00 00 00    	jne    80106eee <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106e56:	8b 75 18             	mov    0x18(%ebp),%esi
80106e59:	31 db                	xor    %ebx,%ebx
80106e5b:	85 f6                	test   %esi,%esi
80106e5d:	75 1a                	jne    80106e79 <loaduvm+0x39>
80106e5f:	eb 77                	jmp    80106ed8 <loaduvm+0x98>
80106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e77:	76 5f                	jbe    80106ed8 <loaduvm+0x98>
80106e79:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e7c:	31 c9                	xor    %ecx,%ecx
80106e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106e81:	01 da                	add    %ebx,%edx
80106e83:	e8 b8 fa ff ff       	call   80106940 <walkpgdir>
80106e88:	85 c0                	test   %eax,%eax
80106e8a:	74 56                	je     80106ee2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106e8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106e8e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106e93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106e9b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106ea1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ea4:	05 00 00 00 80       	add    $0x80000000,%eax
80106ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ead:	8b 45 10             	mov    0x10(%ebp),%eax
80106eb0:	01 d9                	add    %ebx,%ecx
80106eb2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106eb6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106eba:	89 04 24             	mov    %eax,(%esp)
80106ebd:	e8 ae aa ff ff       	call   80101970 <readi>
80106ec2:	39 f8                	cmp    %edi,%eax
80106ec4:	74 a2                	je     80106e68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106ec6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ece:	5b                   	pop    %ebx
80106ecf:	5e                   	pop    %esi
80106ed0:	5f                   	pop    %edi
80106ed1:	5d                   	pop    %ebp
80106ed2:	c3                   	ret    
80106ed3:	90                   	nop
80106ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ed8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106edb:	31 c0                	xor    %eax,%eax
}
80106edd:	5b                   	pop    %ebx
80106ede:	5e                   	pop    %esi
80106edf:	5f                   	pop    %edi
80106ee0:	5d                   	pop    %ebp
80106ee1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106ee2:	c7 04 24 5f 7d 10 80 	movl   $0x80107d5f,(%esp)
80106ee9:	e8 72 94 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106eee:	c7 04 24 00 7e 10 80 	movl   $0x80107e00,(%esp)
80106ef5:	e8 66 94 ff ff       	call   80100360 <panic>
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106f0c:	85 ff                	test   %edi,%edi
80106f0e:	0f 88 7e 00 00 00    	js     80106f92 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106f14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106f1a:	72 78                	jb     80106f94 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106f1c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f22:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f28:	39 df                	cmp    %ebx,%edi
80106f2a:	77 4a                	ja     80106f76 <allocuvm+0x76>
80106f2c:	eb 72                	jmp    80106fa0 <allocuvm+0xa0>
80106f2e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106f30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f37:	00 
80106f38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f3f:	00 
80106f40:	89 04 24             	mov    %eax,(%esp)
80106f43:	e8 08 d5 ff ff       	call   80104450 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f48:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f53:	89 04 24             	mov    %eax,(%esp)
80106f56:	8b 45 08             	mov    0x8(%ebp),%eax
80106f59:	89 da                	mov    %ebx,%edx
80106f5b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106f62:	00 
80106f63:	e8 68 fa ff ff       	call   801069d0 <mappages>
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	78 44                	js     80106fb0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106f6c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f72:	39 df                	cmp    %ebx,%edi
80106f74:	76 2a                	jbe    80106fa0 <allocuvm+0xa0>
    mem = kalloc();
80106f76:	e8 35 b6 ff ff       	call   801025b0 <kalloc>
    if(mem == 0){
80106f7b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106f7d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f7f:	75 af                	jne    80106f30 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106f81:	c7 04 24 7d 7d 10 80 	movl   $0x80107d7d,(%esp)
80106f88:	e8 c3 96 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106f8d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f90:	77 48                	ja     80106fda <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106f92:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106f94:	83 c4 1c             	add    $0x1c,%esp
80106f97:	5b                   	pop    %ebx
80106f98:	5e                   	pop    %esi
80106f99:	5f                   	pop    %edi
80106f9a:	5d                   	pop    %ebp
80106f9b:	c3                   	ret    
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fa0:	83 c4 1c             	add    $0x1c,%esp
80106fa3:	89 f8                	mov    %edi,%eax
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106fb0:	c7 04 24 95 7d 10 80 	movl   $0x80107d95,(%esp)
80106fb7:	e8 94 96 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106fbc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106fbf:	76 0d                	jbe    80106fce <allocuvm+0xce>
80106fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fc4:	89 fa                	mov    %edi,%edx
80106fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc9:	e8 82 fa ff ff       	call   80106a50 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106fce:	89 34 24             	mov    %esi,(%esp)
80106fd1:	e8 2a b4 ff ff       	call   80102400 <kfree>
      return 0;
80106fd6:	31 c0                	xor    %eax,%eax
80106fd8:	eb ba                	jmp    80106f94 <allocuvm+0x94>
80106fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fdd:	89 fa                	mov    %edi,%edx
80106fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe2:	e8 69 fa ff ff       	call   80106a50 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106fe7:	31 c0                	xor    %eax,%eax
80106fe9:	eb a9                	jmp    80106f94 <allocuvm+0x94>
80106feb:	90                   	nop
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ff6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106ffc:	39 d1                	cmp    %edx,%ecx
80106ffe:	73 08                	jae    80107008 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107000:	5d                   	pop    %ebp
80107001:	e9 4a fa ff ff       	jmp    80106a50 <deallocuvm.part.0>
80107006:	66 90                	xchg   %ax,%ax
80107008:	89 d0                	mov    %edx,%eax
8010700a:	5d                   	pop    %ebp
8010700b:	c3                   	ret    
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	56                   	push   %esi
80107014:	53                   	push   %ebx
80107015:	83 ec 10             	sub    $0x10,%esp
80107018:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010701b:	85 f6                	test   %esi,%esi
8010701d:	74 59                	je     80107078 <freevm+0x68>
8010701f:	31 c9                	xor    %ecx,%ecx
80107021:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107026:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107028:	31 db                	xor    %ebx,%ebx
8010702a:	e8 21 fa ff ff       	call   80106a50 <deallocuvm.part.0>
8010702f:	eb 12                	jmp    80107043 <freevm+0x33>
80107031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107038:	83 c3 01             	add    $0x1,%ebx
8010703b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80107041:	74 27                	je     8010706a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107043:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80107046:	f6 c2 01             	test   $0x1,%dl
80107049:	74 ed                	je     80107038 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010704b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107051:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107054:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010705a:	89 14 24             	mov    %edx,(%esp)
8010705d:	e8 9e b3 ff ff       	call   80102400 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107062:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80107068:	75 d9                	jne    80107043 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010706a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010706d:	83 c4 10             	add    $0x10,%esp
80107070:	5b                   	pop    %ebx
80107071:	5e                   	pop    %esi
80107072:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107073:	e9 88 b3 ff ff       	jmp    80102400 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107078:	c7 04 24 b1 7d 10 80 	movl   $0x80107db1,(%esp)
8010707f:	e8 dc 92 ff ff       	call   80100360 <panic>
80107084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010708a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107090 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107090:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107091:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107093:	89 e5                	mov    %esp,%ebp
80107095:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107098:	8b 55 0c             	mov    0xc(%ebp),%edx
8010709b:	8b 45 08             	mov    0x8(%ebp),%eax
8010709e:	e8 9d f8 ff ff       	call   80106940 <walkpgdir>
  if(pte == 0)
801070a3:	85 c0                	test   %eax,%eax
801070a5:	74 05                	je     801070ac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070a7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070aa:	c9                   	leave  
801070ab:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801070ac:	c7 04 24 c2 7d 10 80 	movl   $0x80107dc2,(%esp)
801070b3:	e8 a8 92 ff ff       	call   80100360 <panic>
801070b8:	90                   	nop
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070c9:	e8 62 fb ff ff       	call   80106c30 <setupkvm>
801070ce:	85 c0                	test   %eax,%eax
801070d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070d3:	0f 84 b2 00 00 00    	je     8010718b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070dc:	85 c0                	test   %eax,%eax
801070de:	0f 84 9c 00 00 00    	je     80107180 <copyuvm+0xc0>
801070e4:	31 db                	xor    %ebx,%ebx
801070e6:	eb 48                	jmp    80107130 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070e8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801070ee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801070f5:	00 
801070f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801070fa:	89 04 24             	mov    %eax,(%esp)
801070fd:	e8 ee d3 ff ff       	call   801044f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107105:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
8010710b:	89 14 24             	mov    %edx,(%esp)
8010710e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107113:	89 da                	mov    %ebx,%edx
80107115:	89 44 24 04          	mov    %eax,0x4(%esp)
80107119:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010711c:	e8 af f8 ff ff       	call   801069d0 <mappages>
80107121:	85 c0                	test   %eax,%eax
80107123:	78 41                	js     80107166 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107125:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010712b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010712e:	76 50                	jbe    80107180 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107130:	8b 45 08             	mov    0x8(%ebp),%eax
80107133:	31 c9                	xor    %ecx,%ecx
80107135:	89 da                	mov    %ebx,%edx
80107137:	e8 04 f8 ff ff       	call   80106940 <walkpgdir>
8010713c:	85 c0                	test   %eax,%eax
8010713e:	74 5b                	je     8010719b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107140:	8b 30                	mov    (%eax),%esi
80107142:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107148:	74 45                	je     8010718f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010714a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
8010714c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107152:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107155:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010715b:	e8 50 b4 ff ff       	call   801025b0 <kalloc>
80107160:	85 c0                	test   %eax,%eax
80107162:	89 c6                	mov    %eax,%esi
80107164:	75 82                	jne    801070e8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107166:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107169:	89 04 24             	mov    %eax,(%esp)
8010716c:	e8 9f fe ff ff       	call   80107010 <freevm>
  return 0;
80107171:	31 c0                	xor    %eax,%eax
}
80107173:	83 c4 2c             	add    $0x2c,%esp
80107176:	5b                   	pop    %ebx
80107177:	5e                   	pop    %esi
80107178:	5f                   	pop    %edi
80107179:	5d                   	pop    %ebp
8010717a:	c3                   	ret    
8010717b:	90                   	nop
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107180:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107183:	83 c4 2c             	add    $0x2c,%esp
80107186:	5b                   	pop    %ebx
80107187:	5e                   	pop    %esi
80107188:	5f                   	pop    %edi
80107189:	5d                   	pop    %ebp
8010718a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010718b:	31 c0                	xor    %eax,%eax
8010718d:	eb e4                	jmp    80107173 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010718f:	c7 04 24 e6 7d 10 80 	movl   $0x80107de6,(%esp)
80107196:	e8 c5 91 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010719b:	c7 04 24 cc 7d 10 80 	movl   $0x80107dcc,(%esp)
801071a2:	e8 b9 91 ff ff       	call   80100360 <panic>
801071a7:	89 f6                	mov    %esi,%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071b1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071b3:	89 e5                	mov    %esp,%ebp
801071b5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071bb:	8b 45 08             	mov    0x8(%ebp),%eax
801071be:	e8 7d f7 ff ff       	call   80106940 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071c3:	8b 00                	mov    (%eax),%eax
801071c5:	89 c2                	mov    %eax,%edx
801071c7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
801071ca:	83 fa 05             	cmp    $0x5,%edx
801071cd:	75 11                	jne    801071e0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071d4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801071d9:	c9                   	leave  
801071da:	c3                   	ret    
801071db:	90                   	nop
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801071e0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801071e2:	c9                   	leave  
801071e3:	c3                   	ret    
801071e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801071fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107202:	85 db                	test   %ebx,%ebx
80107204:	75 3a                	jne    80107240 <copyout+0x50>
80107206:	eb 68                	jmp    80107270 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107208:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010720b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010720d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107211:	29 ca                	sub    %ecx,%edx
80107213:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107219:	39 da                	cmp    %ebx,%edx
8010721b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010721e:	29 f1                	sub    %esi,%ecx
80107220:	01 c8                	add    %ecx,%eax
80107222:	89 54 24 08          	mov    %edx,0x8(%esp)
80107226:	89 04 24             	mov    %eax,(%esp)
80107229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010722c:	e8 bf d2 ff ff       	call   801044f0 <memmove>
    len -= n;
    buf += n;
80107231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107234:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010723a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010723c:	29 d3                	sub    %edx,%ebx
8010723e:	74 30                	je     80107270 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107240:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107243:	89 ce                	mov    %ecx,%esi
80107245:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010724b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010724f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107252:	89 04 24             	mov    %eax,(%esp)
80107255:	e8 56 ff ff ff       	call   801071b0 <uva2ka>
    if(pa0 == 0)
8010725a:	85 c0                	test   %eax,%eax
8010725c:	75 aa                	jne    80107208 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010725e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107266:	5b                   	pop    %ebx
80107267:	5e                   	pop    %esi
80107268:	5f                   	pop    %edi
80107269:	5d                   	pop    %ebp
8010726a:	c3                   	ret    
8010726b:	90                   	nop
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107270:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
