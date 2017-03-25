
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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 2e 10 80       	mov    $0x80102ef0,%eax
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
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 6f 10 80       	push   $0x80106fa0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 05 42 00 00       	call   80104260 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 6f 10 80       	push   $0x80106fa7
80100097:	50                   	push   %eax
80100098:	e8 b3 40 00 00       	call   80104150 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
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
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 97 41 00 00       	call   80104280 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
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
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 f9 42 00 00       	call   80104460 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 40 00 00       	call   80104190 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 6f 10 80       	push   $0x80106fae
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 7d 40 00 00       	call   80104230 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 6f 10 80       	push   $0x80106fbf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
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
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 3c 40 00 00       	call   80104230 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 3f 00 00       	call   801041f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 70 40 00 00       	call   80104280 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 ff 41 00 00       	jmp    80104460 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 6f 10 80       	push   $0x80106fc6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

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
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 ef 3f 00 00       	call   80104280 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 3e 3b 00 00       	call   80103e00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 24             	mov    0x24(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 74 41 00 00       	call   80104460 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 8c 13 00 00       	call   80101680 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 15 41 00 00       	call   80104460 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 2d 13 00 00       	call   80101680 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 cd 6f 10 80       	push   $0x80106fcd
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 c6 74 10 80 	movl   $0x801074c6,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 92 3f 00 00       	call   80104350 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 e9 6f 10 80       	push   $0x80106fe9
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 57 00 00       	call   80105b60 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 88 56 00 00       	call   80105b60 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 56 00 00       	call   80105b60 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 56 00 00       	call   80105b60 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 47 40 00 00       	call   80104560 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 82 3f 00 00       	call   801044b0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 ed 6f 10 80       	push   $0x80106fed
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 18 70 10 80 	movzbl -0x7fef8fe8(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 60 3c 00 00       	call   80104280 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 14 3e 00 00       	call   80104460 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 4e 3d 00 00       	call   80104460 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 00 70 10 80       	mov    $0x80107000,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 b3 3a 00 00       	call   80104280 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 07 70 10 80       	push   $0x80107007
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 78 3a 00 00       	call   80104280 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 f3 3b 00 00       	call   80104460 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 a5 36 00 00       	call   80103fa0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 14 37 00 00       	jmp    80104090 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 10 70 10 80       	push   $0x80107010
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 ab 38 00 00       	call   80104260 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 d1 28 00 00       	call   801032b0 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 c6 18 00 00       	call   801022b0 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <pseudo_main>:
#include "x86.h"
#include "elf.h"

void 
pseudo_main(int (*entry)(int, char**), int argc, char **argv) 
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
}
801009f3:	5d                   	pop    %ebp
801009f4:	c3                   	ret    
801009f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a00 <exec>:

int
exec(char *path, char **argv)
{
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	57                   	push   %edi
80100a04:	56                   	push   %esi
80100a05:	53                   	push   %ebx
80100a06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100a0c:	e8 cf 21 00 00       	call   80102be0 <begin_op>

  if((ip = namei(path)) == 0){
80100a11:	83 ec 0c             	sub    $0xc,%esp
80100a14:	ff 75 08             	pushl  0x8(%ebp)
80100a17:	e8 94 14 00 00       	call   80101eb0 <namei>
80100a1c:	83 c4 10             	add    $0x10,%esp
80100a1f:	85 c0                	test   %eax,%eax
80100a21:	0f 84 9f 01 00 00    	je     80100bc6 <exec+0x1c6>
    end_op();
    return -1;
  }
  ilock(ip);
80100a27:	83 ec 0c             	sub    $0xc,%esp
80100a2a:	89 c3                	mov    %eax,%ebx
80100a2c:	50                   	push   %eax
80100a2d:	e8 4e 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a32:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a38:	6a 34                	push   $0x34
80100a3a:	6a 00                	push   $0x0
80100a3c:	50                   	push   %eax
80100a3d:	53                   	push   %ebx
80100a3e:	e8 fd 0e 00 00       	call   80101940 <readi>
80100a43:	83 c4 20             	add    $0x20,%esp
80100a46:	83 f8 34             	cmp    $0x34,%eax
80100a49:	74 25                	je     80100a70 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a4b:	83 ec 0c             	sub    $0xc,%esp
80100a4e:	53                   	push   %ebx
80100a4f:	e8 9c 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a54:	e8 f7 21 00 00       	call   80102c50 <end_op>
80100a59:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a64:	5b                   	pop    %ebx
80100a65:	5e                   	pop    %esi
80100a66:	5f                   	pop    %edi
80100a67:	5d                   	pop    %ebp
80100a68:	c3                   	ret    
80100a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a77:	45 4c 46 
80100a7a:	75 cf                	jne    80100a4b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a7c:	e8 9f 5e 00 00       	call   80106920 <setupkvm>
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a89:	74 c0                	je     80100a4b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a92:	00 
80100a93:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100aa0:	00 00 00 
80100aa3:	0f 84 c5 00 00 00    	je     80100b6e <exec+0x16e>
80100aa9:	31 ff                	xor    %edi,%edi
80100aab:	eb 18                	jmp    80100ac5 <exec+0xc5>
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
80100ab0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ab7:	83 c7 01             	add    $0x1,%edi
80100aba:	83 c6 20             	add    $0x20,%esi
80100abd:	39 f8                	cmp    %edi,%eax
80100abf:	0f 8e a9 00 00 00    	jle    80100b6e <exec+0x16e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ac5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100acb:	6a 20                	push   $0x20
80100acd:	56                   	push   %esi
80100ace:	50                   	push   %eax
80100acf:	53                   	push   %ebx
80100ad0:	e8 6b 0e 00 00       	call   80101940 <readi>
80100ad5:	83 c4 10             	add    $0x10,%esp
80100ad8:	83 f8 20             	cmp    $0x20,%eax
80100adb:	75 7b                	jne    80100b58 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100add:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae4:	75 ca                	jne    80100ab0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ae6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aec:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af2:	72 64                	jb     80100b58 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100af4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100afa:	72 5c                	jb     80100b58 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100afc:	83 ec 04             	sub    $0x4,%esp
80100aff:	50                   	push   %eax
80100b00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b06:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b0c:	e8 cf 60 00 00       	call   80106be0 <allocuvm>
80100b11:	83 c4 10             	add    $0x10,%esp
80100b14:	85 c0                	test   %eax,%eax
80100b16:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b1c:	74 3a                	je     80100b58 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b1e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b24:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b29:	75 2d                	jne    80100b58 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b34:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b3a:	53                   	push   %ebx
80100b3b:	50                   	push   %eax
80100b3c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b42:	e8 d9 5f 00 00       	call   80106b20 <loaduvm>
80100b47:	83 c4 20             	add    $0x20,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 89 5e ff ff ff    	jns    80100ab0 <exec+0xb0>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b61:	e8 aa 61 00 00       	call   80106d10 <freevm>
80100b66:	83 c4 10             	add    $0x10,%esp
80100b69:	e9 dd fe ff ff       	jmp    80100a4b <exec+0x4b>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	53                   	push   %ebx
80100b72:	e8 79 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b77:	e8 d4 20 00 00       	call   80102c50 <end_op>

  pointer_pseudo_main = sz;  

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
80100b82:	83 c4 0c             	add    $0xc,%esp

  pointer_pseudo_main = sz;  

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b85:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
80100b8f:	8d 90 00 30 00 00    	lea    0x3000(%eax),%edx
80100b95:	52                   	push   %edx
80100b96:	50                   	push   %eax
80100b97:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b9d:	e8 3e 60 00 00       	call   80106be0 <allocuvm>
80100ba2:	83 c4 10             	add    $0x10,%esp
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	89 c3                	mov    %eax,%ebx
80100ba9:	75 2a                	jne    80100bd5 <exec+0x1d5>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bb4:	e8 57 61 00 00       	call   80106d10 <freevm>
80100bb9:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc1:	e9 9b fe ff ff       	jmp    80100a61 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bc6:	e8 85 20 00 00       	call   80102c50 <end_op>
    return -1;
80100bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd0:	e9 8c fe ff ff       	jmp    80100a61 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd5:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100bdb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be1:	83 ec 08             	sub    $0x8,%esp
80100be4:	50                   	push   %eax
80100be5:	57                   	push   %edi
80100be6:	e8 a5 61 00 00       	call   80106d90 <clearpteu>
  
  if (copyout(pgdir, pointer_pseudo_main, pseudo_main, (uint)exec - (uint)pseudo_main) < 0)
80100beb:	b8 00 0a 10 80       	mov    $0x80100a00,%eax
80100bf0:	2d f0 09 10 80       	sub    $0x801009f0,%eax
80100bf5:	50                   	push   %eax
80100bf6:	68 f0 09 10 80       	push   $0x801009f0
80100bfb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c01:	57                   	push   %edi
80100c02:	e8 e9 62 00 00       	call   80106ef0 <copyout>
80100c07:	83 c4 20             	add    $0x20,%esp
80100c0a:	85 c0                	test   %eax,%eax
80100c0c:	78 9d                	js     80100bab <exec+0x1ab>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c11:	31 ff                	xor    %edi,%edi
80100c13:	89 de                	mov    %ebx,%esi
80100c15:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c1b:	8b 00                	mov    (%eax),%eax
80100c1d:	85 c0                	test   %eax,%eax
80100c1f:	74 70                	je     80100c91 <exec+0x291>
80100c21:	89 9d f0 fe ff ff    	mov    %ebx,-0x110(%ebp)
80100c27:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100c2d:	eb 0a                	jmp    80100c39 <exec+0x239>
80100c2f:	90                   	nop
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	0f 84 72 ff ff ff    	je     80100bab <exec+0x1ab>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c39:	83 ec 0c             	sub    $0xc,%esp
80100c3c:	50                   	push   %eax
80100c3d:	e8 ae 3a 00 00       	call   801046f0 <strlen>
80100c42:	f7 d0                	not    %eax
80100c44:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c46:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c49:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4a:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c50:	e8 9b 3a 00 00       	call   801046f0 <strlen>
80100c55:	83 c0 01             	add    $0x1,%eax
80100c58:	50                   	push   %eax
80100c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5f:	56                   	push   %esi
80100c60:	53                   	push   %ebx
80100c61:	e8 8a 62 00 00       	call   80106ef0 <copyout>
80100c66:	83 c4 20             	add    $0x20,%esp
80100c69:	85 c0                	test   %eax,%eax
80100c6b:	0f 88 3a ff ff ff    	js     80100bab <exec+0x1ab>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c71:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c74:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c7b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c7e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c84:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c87:	85 c0                	test   %eax,%eax
80100c89:	75 a5                	jne    80100c30 <exec+0x230>
80100c8b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c98:	89 f1                	mov    %esi,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c9a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ca1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ca5:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cac:	ff ff ff 
  ustack[1] = argc;
80100caf:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100cb7:	83 c0 0c             	add    $0xc,%eax
80100cba:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbc:	50                   	push   %eax
80100cbd:	52                   	push   %edx
80100cbe:	56                   	push   %esi
80100cbf:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ccb:	e8 20 62 00 00       	call   80106ef0 <copyout>
80100cd0:	83 c4 10             	add    $0x10,%esp
80100cd3:	85 c0                	test   %eax,%eax
80100cd5:	0f 88 d0 fe ff ff    	js     80100bab <exec+0x1ab>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cde:	0f b6 10             	movzbl (%eax),%edx
80100ce1:	84 d2                	test   %dl,%dl
80100ce3:	74 19                	je     80100cfe <exec+0x2fe>
80100ce5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ce8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ceb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cee:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cf1:	0f 44 c8             	cmove  %eax,%ecx
80100cf4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cf7:	84 d2                	test   %dl,%dl
80100cf9:	75 f0                	jne    80100ceb <exec+0x2eb>
80100cfb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cfe:	50                   	push   %eax
80100cff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d05:	6a 10                	push   $0x10
80100d07:	ff 75 08             	pushl  0x8(%ebp)
80100d0a:	83 c0 6c             	add    $0x6c,%eax
80100d0d:	50                   	push   %eax
80100d0e:	e8 9d 39 00 00       	call   801046b0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100d19:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d1f:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100d22:	89 18                	mov    %ebx,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100d24:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100d27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d2d:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d33:	8b 50 18             	mov    0x18(%eax),%edx
80100d36:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d39:	8b 50 18             	mov    0x18(%eax),%edx
80100d3c:	89 72 44             	mov    %esi,0x44(%edx)
  switchuvm(proc);
80100d3f:	89 04 24             	mov    %eax,(%esp)
80100d42:	e8 89 5c 00 00       	call   801069d0 <switchuvm>
  freevm(oldpgdir);
80100d47:	89 3c 24             	mov    %edi,(%esp)
80100d4a:	e8 c1 5f 00 00       	call   80106d10 <freevm>
  return 0;
80100d4f:	83 c4 10             	add    $0x10,%esp
80100d52:	31 c0                	xor    %eax,%eax
80100d54:	e9 08 fd ff ff       	jmp    80100a61 <exec+0x61>
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 29 70 10 80       	push   $0x80107029
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 eb 34 00 00       	call   80104260 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 ea 34 00 00       	call   80104280 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 9a 36 00 00       	call   80104460 <release>
      return f;
80100dc6:	89 d8                	mov    %ebx,%eax
80100dc8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
80100dd3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dd8:	e8 83 36 00 00       	call   80104460 <release>
  return 0;
80100ddd:	83 c4 10             	add    $0x10,%esp
80100de0:	31 c0                	xor    %eax,%eax
}
80100de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de5:	c9                   	leave  
80100de6:	c3                   	ret    
80100de7:	89 f6                	mov    %esi,%esi
80100de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dff:	e8 7c 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e1c:	e8 3f 36 00 00       	call   80104460 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 30 70 10 80       	push   $0x80107030
80100e30:	e8 3b f5 ff ff       	call   80100370 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e51:	e8 2a 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100e56:	8b 47 04             	mov    0x4(%edi),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 47 04             	mov    %eax,0x4(%edi)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e7c:	e9 df 35 00 00       	jmp    80104460 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e88:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e8c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e91:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e94:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ea0:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ea8:	e8 b3 35 00 00       	call   80104460 <release>

  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 fb 01             	cmp    $0x1,%ebx
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100eb5:	83 fb 02             	cmp    $0x2,%ebx
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 aa 25 00 00       	call   80103480 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ee0:	e8 fb 1c 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100efa:	e9 51 1d 00 00       	jmp    80102c50 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 38 70 10 80       	push   $0x80107038
80100f07:	e8 64 f4 ff ff       	call   80100370 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 d9 09 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 a4 09 00 00       	call   80101940 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fb6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fcd:	e9 7e 26 00 00       	jmp    80103650 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fdd:	eb d9                	jmp    80100fb8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 42 70 10 80       	push   $0x80107042
80100fe7:	e8 84 f3 ff ff       	call   80100370 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d8 00 00 00    	jne    801010fe <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 ff                	xor    %edi,%edi
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 02 1c 00 00       	call   80102c50 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 d8                	cmp    %ebx,%eax
80101056:	0f 85 95 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010105c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101076:	e8 65 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 a8 09 00 00       	call   80101a40 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 9e 1b 00 00       	call   80102c50 <end_op>

      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010c4:	5b                   	pop    %ebx
801010c5:	5e                   	pop    %esi
801010c6:	5f                   	pop    %edi
801010c7:	5d                   	pop    %ebp
801010c8:	c3                   	ret    
801010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010d0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010df:	8b 46 0c             	mov    0xc(%esi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 2f 24 00 00       	jmp    80103520 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010f1:	83 ec 0c             	sub    $0xc,%esp
801010f4:	68 4b 70 10 80       	push   $0x8010704b
801010f9:	e8 72 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010fe:	83 ec 0c             	sub    $0xc,%esp
80101101:	68 51 70 10 80       	push   $0x80107051
80101106:	e8 65 f2 ff ff       	call   80100370 <panic>
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 85 00 00 00    	je     801011af <balloc+0x9f>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2d                	jmp    8010118a <balloc+0x7a>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
80101162:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101167:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101179:	85 d7                	test   %edx,%edi
8010117b:	74 43                	je     801011c0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117d:	83 c0 01             	add    $0x1,%eax
80101180:	83 c6 01             	add    $0x1,%esi
80101183:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101188:	74 05                	je     8010118f <balloc+0x7f>
8010118a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010118d:	72 d1                	jb     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	ff 75 e4             	pushl  -0x1c(%ebp)
80101195:	e8 46 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010119a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a1:	83 c4 10             	add    $0x10,%esp
801011a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a7:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011ad:	77 82                	ja     80101131 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 5b 70 10 80       	push   $0x8010705b
801011b7:	e8 b4 f1 ff ff       	call   80100370 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	09 fa                	or     %edi,%edx
801011c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ee 1b 00 00       	call   80102dc0 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 b6 32 00 00       	call   801044b0 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 be 1b 00 00       	call   80102dc0 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101235:	68 00 0a 11 80       	push   $0x80110a00
8010123a:	e8 41 30 00 00       	call   80104280 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 1b                	jmp    80101262 <iget+0x42>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101250:	85 f6                	test   %esi,%esi
80101252:	74 44                	je     80101298 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101254:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010125a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101260:	74 4e                	je     801012b0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101262:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101265:	85 c9                	test   %ecx,%ecx
80101267:	7e e7                	jle    80101250 <iget+0x30>
80101269:	39 3b                	cmp    %edi,(%ebx)
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101270:	75 de                	jne    80101250 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101272:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101275:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101278:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010127a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010127f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101282:	e8 d9 31 00 00       	call   80104460 <release>
      return ip;
80101287:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101298:	85 c9                	test   %ecx,%ecx
8010129a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129d:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a3:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012a9:	75 b7                	jne    80101262 <iget+0x42>
801012ab:	90                   	nop
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 2d                	je     801012e1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ca:	68 00 0a 11 80       	push   $0x80110a00
801012cf:	e8 8c 31 00 00       	call   80104460 <release>

  return ip;
801012d4:	83 c4 10             	add    $0x10,%esp
}
801012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012da:	89 f0                	mov    %esi,%eax
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 71 70 10 80       	push   $0x80107071
801012e9:	e8 82 f0 ff ff       	call   80100370 <panic>
801012ee:	66 90                	xchg   %ax,%ax

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	5b                   	pop    %ebx
8010130e:	5e                   	pop    %esi
8010130f:	5f                   	pop    %edi
80101310:	5d                   	pop    %ebp
80101311:	c3                   	ret    
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 83 00 00 00    	ja     801013a7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010132a:	85 c0                	test   %eax,%eax
8010132c:	74 6a                	je     80101398 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132e:	83 ec 08             	sub    $0x8,%esp
80101331:	50                   	push   %eax
80101332:	ff 36                	pushl  (%esi)
80101334:	e8 97 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101339:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101340:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101342:	8b 1a                	mov    (%edx),%ebx
80101344:	85 db                	test   %ebx,%ebx
80101346:	75 1d                	jne    80101365 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101348:	8b 06                	mov    (%esi),%eax
8010134a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134d:	e8 be fd ff ff       	call   80101110 <balloc>
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101358:	89 c3                	mov    %eax,%ebx
8010135a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135c:	57                   	push   %edi
8010135d:	e8 5e 1a 00 00       	call   80102dc0 <log_write>
80101362:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101365:	83 ec 0c             	sub    $0xc,%esp
80101368:	57                   	push   %edi
80101369:	e8 72 ee ff ff       	call   801001e0 <brelse>
8010136e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101371:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101374:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101376:	5b                   	pop    %ebx
80101377:	5e                   	pop    %esi
80101378:	5f                   	pop    %edi
80101379:	5d                   	pop    %ebp
8010137a:	c3                   	ret    
8010137b:	90                   	nop
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 06                	mov    (%esi),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101398:	8b 06                	mov    (%esi),%eax
8010139a:	e8 71 fd ff ff       	call   80101110 <balloc>
8010139f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013a5:	eb 87                	jmp    8010132e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013a7:	83 ec 0c             	sub    $0xc,%esp
801013aa:	68 81 70 10 80       	push   $0x80107081
801013af:	e8 bc ef ff ff       	call   80100370 <panic>
801013b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013c0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013c8:	83 ec 08             	sub    $0x8,%esp
801013cb:	6a 01                	push   $0x1
801013cd:	ff 75 08             	pushl  0x8(%ebp)
801013d0:	e8 fb ec ff ff       	call   801000d0 <bread>
801013d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	6a 1c                	push   $0x1c
801013df:	50                   	push   %eax
801013e0:	56                   	push   %esi
801013e1:	e8 7a 31 00 00       	call   80104560 <memmove>
  brelse(bp);
801013e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013e9:	83 c4 10             	add    $0x10,%esp
}
801013ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ef:	5b                   	pop    %ebx
801013f0:	5e                   	pop    %esi
801013f1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013f2:	e9 e9 ed ff ff       	jmp    801001e0 <brelse>
801013f7:	89 f6                	mov    %esi,%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	89 d3                	mov    %edx,%ebx
80101407:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101409:	83 ec 08             	sub    $0x8,%esp
8010140c:	68 e0 09 11 80       	push   $0x801109e0
80101411:	50                   	push   %eax
80101412:	e8 a9 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101417:	58                   	pop    %eax
80101418:	5a                   	pop    %edx
80101419:	89 da                	mov    %ebx,%edx
8010141b:	c1 ea 0c             	shr    $0xc,%edx
8010141e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101424:	52                   	push   %edx
80101425:	56                   	push   %esi
80101426:	e8 a5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010142b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101433:	ba 01 00 00 00       	mov    $0x1,%edx
80101438:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143b:	c1 fb 03             	sar    $0x3,%ebx
8010143e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101441:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101443:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101448:	85 d1                	test   %edx,%ecx
8010144a:	74 27                	je     80101473 <bfree+0x73>
8010144c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010144e:	f7 d2                	not    %edx
80101450:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101452:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101455:	21 d0                	and    %edx,%eax
80101457:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010145b:	56                   	push   %esi
8010145c:	e8 5f 19 00 00       	call   80102dc0 <log_write>
  brelse(bp);
80101461:	89 34 24             	mov    %esi,(%esp)
80101464:	e8 77 ed ff ff       	call   801001e0 <brelse>
}
80101469:	83 c4 10             	add    $0x10,%esp
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
80101472:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101473:	83 ec 0c             	sub    $0xc,%esp
80101476:	68 94 70 10 80       	push   $0x80107094
8010147b:	e8 f0 ee ff ff       	call   80100370 <panic>

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	68 a7 70 10 80       	push   $0x801070a7
80101491:	68 00 0a 11 80       	push   $0x80110a00
80101496:	e8 c5 2d 00 00       	call   80104260 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 ae 70 10 80       	push   $0x801070ae
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 9c 2c 00 00       	call   80104150 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 09 11 80       	push   $0x801109e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 f1 fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014d5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014db:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014e1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014e7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014ed:	ff 35 e4 09 11 80    	pushl  0x801109e4
801014f3:	ff 35 e0 09 11 80    	pushl  0x801109e0
801014f9:	68 04 71 10 80       	push   $0x80107104
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 1d 2f 00 00       	call   801044b0 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 1b 18 00 00       	call   80102dc0 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015bb:	e9 60 fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 b4 70 10 80       	push   $0x801070b4
801015c8:	e8 a3 ed ff ff       	call   80100370 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 2a 2f 00 00       	call   80104560 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 82 17 00 00       	call   80102dc0 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 0a 11 80       	push   $0x80110a00
8010165f:	e8 1c 2c 00 00       	call   80104280 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010166f:	e8 ec 2d 00 00       	call   80104460 <release>
  return ip;
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b4 00 00 00    	je     80101744 <ilock+0xc4>
80101690:	8b 43 08             	mov    0x8(%ebx),%eax
80101693:	85 c0                	test   %eax,%eax
80101695:	0f 8e a9 00 00 00    	jle    80101744 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 e9 2a 00 00       	call   80104190 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016a7:	83 c4 10             	add    $0x10,%esp
801016aa:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016ae:	74 10                	je     801016c0 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b3:	5b                   	pop    %ebx
801016b4:	5e                   	pop    %esi
801016b5:	5d                   	pop    %ebp
801016b6:	c3                   	ret    
801016b7:	89 f6                	mov    %esi,%esi
801016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 43 2e 00 00       	call   80104560 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101725:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
80101729:	83 c4 10             	add    $0x10,%esp
8010172c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101731:	0f 85 79 ff ff ff    	jne    801016b0 <ilock+0x30>
      panic("ilock: no type");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 cc 70 10 80       	push   $0x801070cc
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101744:	83 ec 0c             	sub    $0xc,%esp
80101747:	68 c6 70 10 80       	push   $0x801070c6
8010174c:	e8 1f ec ff ff       	call   80100370 <panic>
80101751:	eb 0d                	jmp    80101760 <iunlock>
80101753:	90                   	nop
80101754:	90                   	nop
80101755:	90                   	nop
80101756:	90                   	nop
80101757:	90                   	nop
80101758:	90                   	nop
80101759:	90                   	nop
8010175a:	90                   	nop
8010175b:	90                   	nop
8010175c:	90                   	nop
8010175d:	90                   	nop
8010175e:	90                   	nop
8010175f:	90                   	nop

80101760 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 b8 2a 00 00       	call   80104230 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010178f:	e9 5c 2a 00 00       	jmp    801041f0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 db 70 10 80       	push   $0x801070db
8010179c:	e8 cf eb ff ff       	call   80100370 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017bc:	68 00 0a 11 80       	push   $0x80110a00
801017c1:	e8 ba 2a 00 00       	call   80104280 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017c6:	8b 46 08             	mov    0x8(%esi),%eax
801017c9:	83 c4 10             	add    $0x10,%esp
801017cc:	83 f8 01             	cmp    $0x1,%eax
801017cf:	74 1f                	je     801017f0 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017d1:	83 e8 01             	sub    $0x1,%eax
801017d4:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017d7:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017e1:	5b                   	pop    %ebx
801017e2:	5e                   	pop    %esi
801017e3:	5f                   	pop    %edi
801017e4:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017e5:	e9 76 2c 00 00       	jmp    80104460 <release>
801017ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017f0:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
801017f4:	74 db                	je     801017d1 <iput+0x21>
801017f6:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017fb:	75 d4                	jne    801017d1 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
801017fd:	83 ec 0c             	sub    $0xc,%esp
80101800:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101803:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
80101809:	68 00 0a 11 80       	push   $0x80110a00
8010180e:	e8 4d 2c 00 00       	call   80104460 <release>
80101813:	83 c4 10             	add    $0x10,%esp
80101816:	eb 0f                	jmp    80101827 <iput+0x77>
80101818:	90                   	nop
80101819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0x90>
    if(ip->addrs[i]){
80101827:	8b 13                	mov    (%ebx),%edx
80101829:	85 d2                	test   %edx,%edx
8010182b:	74 f3                	je     80101820 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
8010182d:	8b 06                	mov    (%esi),%eax
8010182f:	e8 cc fb ff ff       	call   80101400 <bfree>
      ip->addrs[i] = 0;
80101834:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010183a:	eb e4                	jmp    80101820 <iput+0x70>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	85 c0                	test   %eax,%eax
80101848:	75 46                	jne    80101890 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010184a:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010184d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101854:	56                   	push   %esi
80101855:	e8 76 fd ff ff       	call   801015d0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
8010185a:	31 c0                	xor    %eax,%eax
8010185c:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101860:	89 34 24             	mov    %esi,(%esp)
80101863:	e8 68 fd ff ff       	call   801015d0 <iupdate>
    acquire(&icache.lock);
80101868:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010186f:	e8 0c 2a 00 00       	call   80104280 <acquire>
    ip->flags = 0;
80101874:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010187b:	8b 46 08             	mov    0x8(%esi),%eax
8010187e:	83 c4 10             	add    $0x10,%esp
80101881:	e9 4b ff ff ff       	jmp    801017d1 <iput+0x21>
80101886:	8d 76 00             	lea    0x0(%esi),%esi
80101889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	83 c4 10             	add    $0x10,%esp
8010189e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a1:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018a4:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
801018aa:	eb 0b                	jmp    801018b7 <iput+0x107>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018b0:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018b3:	39 df                	cmp    %ebx,%edi
801018b5:	74 0f                	je     801018c6 <iput+0x116>
      if(a[j])
801018b7:	8b 13                	mov    (%ebx),%edx
801018b9:	85 d2                	test   %edx,%edx
801018bb:	74 f3                	je     801018b0 <iput+0x100>
        bfree(ip->dev, a[j]);
801018bd:	8b 06                	mov    (%esi),%eax
801018bf:	e8 3c fb ff ff       	call   80101400 <bfree>
801018c4:	eb ea                	jmp    801018b0 <iput+0x100>
    }
    brelse(bp);
801018c6:	83 ec 0c             	sub    $0xc,%esp
801018c9:	ff 75 e4             	pushl  -0x1c(%ebp)
801018cc:	e8 0f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018d1:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d7:	8b 06                	mov    (%esi),%eax
801018d9:	e8 22 fb ff ff       	call   80101400 <bfree>
    ip->addrs[NDIRECT] = 0;
801018de:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e5:	00 00 00 
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	e9 5a ff ff ff       	jmp    8010184a <iput+0x9a>

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	53                   	push   %ebx
801018fb:	e8 60 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101900:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101903:	83 c4 10             	add    $0x10,%esp
}
80101906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101909:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 a1 fe ff ff       	jmp    801017b0 <iput>
8010190f:	90                   	nop

80101910 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 1c             	sub    $0x1c,%esp
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101952:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101957:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010195d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101960:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101963:	0f 84 a7 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101969:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010196c:	8b 40 58             	mov    0x58(%eax),%eax
8010196f:	39 f0                	cmp    %esi,%eax
80101971:	0f 82 c1 00 00 00    	jb     80101a38 <readi+0xf8>
80101977:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010197a:	89 fa                	mov    %edi,%edx
8010197c:	01 f2                	add    %esi,%edx
8010197e:	0f 82 b4 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101984:	89 c1                	mov    %eax,%ecx
80101986:	29 f1                	sub    %esi,%ecx
80101988:	39 d0                	cmp    %edx,%eax
8010198a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198d:	31 ff                	xor    %edi,%edi
8010198f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101994:	74 6d                	je     80101a03 <readi+0xc3>
80101996:	8d 76 00             	lea    0x0(%esi),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019a3:	89 f2                	mov    %esi,%edx
801019a5:	c1 ea 09             	shr    $0x9,%edx
801019a8:	89 d8                	mov    %ebx,%eax
801019aa:	e8 41 f9 ff ff       	call   801012f0 <bmap>
801019af:	83 ec 08             	sub    $0x8,%esp
801019b2:	50                   	push   %eax
801019b3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019b5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ba:	e8 11 e7 ff ff       	call   801000d0 <bread>
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c4:	89 f1                	mov    %esi,%ecx
801019c6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019cc:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d2:	29 cb                	sub    %ecx,%ebx
801019d4:	29 f8                	sub    %edi,%eax
801019d6:	39 c3                	cmp    %eax,%ebx
801019d8:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019db:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019df:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e0:	01 df                	add    %ebx,%edi
801019e2:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019e4:	50                   	push   %eax
801019e5:	ff 75 e0             	pushl  -0x20(%ebp)
801019e8:	e8 73 2b 00 00       	call   80104560 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a01:	77 9d                	ja     801019a0 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a09:	5b                   	pop    %ebx
80101a0a:	5e                   	pop    %esi
80101a0b:	5f                   	pop    %edi
80101a0c:	5d                   	pop    %ebp
80101a0d:	c3                   	ret    
80101a0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2b:	5b                   	pop    %ebx
80101a2c:	5e                   	pop    %esi
80101a2d:	5f                   	pop    %edi
80101a2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a2f:	ff e0                	jmp    *%eax
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c7                	jmp    80101a06 <readi+0xc6>
80101a3f:	90                   	nop

80101a40 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 eb 00 00 00    	jb     80101b60 <writei+0x120>
80101a75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a78:	89 f8                	mov    %edi,%eax
80101a7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a81:	0f 87 d9 00 00 00    	ja     80101b60 <writei+0x120>
80101a87:	39 c6                	cmp    %eax,%esi
80101a89:	0f 87 d1 00 00 00    	ja     80101b60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8f:	85 ff                	test   %edi,%edi
80101a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a98:	74 78                	je     80101b12 <writei+0xd2>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aa3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	c1 ea 09             	shr    $0x9,%edx
80101aad:	89 f8                	mov    %edi,%eax
80101aaf:	e8 3c f8 ff ff       	call   801012f0 <bmap>
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	50                   	push   %eax
80101ab8:	ff 37                	pushl  (%edi)
80101aba:	e8 11 e6 ff ff       	call   801000d0 <bread>
80101abf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ac7:	89 f1                	mov    %esi,%ecx
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ad2:	29 cb                	sub    %ecx,%ebx
80101ad4:	39 c3                	cmp    %eax,%ebx
80101ad6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101add:	53                   	push   %ebx
80101ade:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	50                   	push   %eax
80101ae4:	e8 77 2a 00 00       	call   80104560 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 cf 12 00 00       	call   80102dc0 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b08:	77 96                	ja     80101aa0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b10:	77 36                	ja     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 36                	ja     80101b60 <writei+0x120>
80101b2a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 2b                	je     80101b60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b51:	50                   	push   %eax
80101b52:	e8 79 fa ff ff       	call   801015d0 <iupdate>
80101b57:	83 c4 10             	add    $0x10,%esp
80101b5a:	eb b6                	jmp    80101b12 <writei+0xd2>
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b65:	eb ae                	jmp    80101b15 <writei+0xd5>
80101b67:	89 f6                	mov    %esi,%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	6a 0e                	push   $0xe
80101b78:	ff 75 0c             	pushl  0xc(%ebp)
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 5d 2a 00 00       	call   801045e0 <strncmp>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 80 00 00 00    	jne    80101c27 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 5b                	jmp    80101c10 <dirlookup+0x80>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 50                	jbe    80101c10 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	6a 10                	push   $0x10
80101bc2:	57                   	push   %edi
80101bc3:	56                   	push   %esi
80101bc4:	53                   	push   %ebx
80101bc5:	e8 76 fd ff ff       	call   80101940 <readi>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	83 f8 10             	cmp    $0x10,%eax
80101bd0:	75 48                	jne    80101c1a <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101bd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd7:	74 df                	je     80101bb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdc:	83 ec 04             	sub    $0x4,%esp
80101bdf:	6a 0e                	push   $0xe
80101be1:	50                   	push   %eax
80101be2:	ff 75 0c             	pushl  0xc(%ebp)
80101be5:	e8 f6 29 00 00       	call   801045e0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	85 c0                	test   %eax,%eax
80101bef:	75 c7                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 05                	je     80101bfd <dirlookup+0x6d>
        *poff = off;
80101bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bfd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c01:	8b 03                	mov    (%ebx),%eax
80101c03:	e8 18 f6 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
80101c0f:	c3                   	ret    
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c13:	31 c0                	xor    %eax,%eax
}
80101c15:	5b                   	pop    %ebx
80101c16:	5e                   	pop    %esi
80101c17:	5f                   	pop    %edi
80101c18:	5d                   	pop    %ebp
80101c19:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c1a:	83 ec 0c             	sub    $0xc,%esp
80101c1d:	68 f5 70 10 80       	push   $0x801070f5
80101c22:	e8 49 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 e3 70 10 80       	push   $0x801070e3
80101c2f:	e8 3c e7 ff ff       	call   80100370 <panic>
80101c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	89 cf                	mov    %ecx,%edi
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c53:	0f 84 53 01 00 00    	je     80101dac <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c5f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c62:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c65:	68 00 0a 11 80       	push   $0x80110a00
80101c6a:	e8 11 26 00 00       	call   80104280 <acquire>
  ip->ref++;
80101c6f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c73:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c7a:	e8 e1 27 00 00       	call   80104460 <release>
80101c7f:	83 c4 10             	add    $0x10,%esp
80101c82:	eb 07                	jmp    80101c8b <namex+0x4b>
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c88:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c8b:	0f b6 03             	movzbl (%ebx),%eax
80101c8e:	3c 2f                	cmp    $0x2f,%al
80101c90:	74 f6                	je     80101c88 <namex+0x48>
    path++;
  if(*path == 0)
80101c92:	84 c0                	test   %al,%al
80101c94:	0f 84 e3 00 00 00    	je     80101d7d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c9a:	0f b6 03             	movzbl (%ebx),%eax
80101c9d:	89 da                	mov    %ebx,%edx
80101c9f:	84 c0                	test   %al,%al
80101ca1:	0f 84 ac 00 00 00    	je     80101d53 <namex+0x113>
80101ca7:	3c 2f                	cmp    $0x2f,%al
80101ca9:	75 09                	jne    80101cb4 <namex+0x74>
80101cab:	e9 a3 00 00 00       	jmp    80101d53 <namex+0x113>
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x7e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x70>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 8d 00 00 00    	jle    80101d58 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 86 28 00 00       	call   80104560 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xb8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	56                   	push   %esi
80101cfc:	e8 7f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d09:	0f 85 7f 00 00 00    	jne    80101d8e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d12:	85 d2                	test   %edx,%edx
80101d14:	74 09                	je     80101d1f <namex+0xdf>
80101d16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d1f:	83 ec 04             	sub    $0x4,%esp
80101d22:	6a 00                	push   $0x0
80101d24:	57                   	push   %edi
80101d25:	56                   	push   %esi
80101d26:	e8 65 fe ff ff       	call   80101b90 <dirlookup>
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 5c                	je     80101d8e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d38:	56                   	push   %esi
80101d39:	e8 22 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 6a fa ff ff       	call   801017b0 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	89 c6                	mov    %eax,%esi
80101d4e:	e9 38 ff ff ff       	jmp    80101c8b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d53:	31 c9                	xor    %ecx,%ecx
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d58:	83 ec 04             	sub    $0x4,%esp
80101d5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d61:	51                   	push   %ecx
80101d62:	53                   	push   %ebx
80101d63:	57                   	push   %edi
80101d64:	e8 f7 27 00 00       	call   80104560 <memmove>
    name[len] = 0;
80101d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d76:	89 d3                	mov    %edx,%ebx
80101d78:	e9 65 ff ff ff       	jmp    80101ce2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	75 54                	jne    80101dd8 <namex+0x198>
80101d84:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d89:	5b                   	pop    %ebx
80101d8a:	5e                   	pop    %esi
80101d8b:	5f                   	pop    %edi
80101d8c:	5d                   	pop    %ebp
80101d8d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	56                   	push   %esi
80101d92:	e8 c9 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 11 fa ff ff       	call   801017b0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d9f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5f                   	pop    %edi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dac:	ba 01 00 00 00       	mov    $0x1,%edx
80101db1:	b8 01 00 00 00       	mov    $0x1,%eax
80101db6:	e8 65 f4 ff ff       	call   80101220 <iget>
80101dbb:	89 c6                	mov    %eax,%esi
80101dbd:	e9 c9 fe ff ff       	jmp    80101c8b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	56                   	push   %esi
80101dc6:	e8 95 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dcb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd3:	5b                   	pop    %ebx
80101dd4:	5e                   	pop    %esi
80101dd5:	5f                   	pop    %edi
80101dd6:	5d                   	pop    %ebp
80101dd7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 cf f9 ff ff       	call   801017b0 <iput>
    return 0;
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	31 c0                	xor    %eax,%eax
80101de6:	eb 9e                	jmp    80101d86 <namex+0x146>
80101de8:	90                   	nop
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 89 fd ff ff       	call   80101b90 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 0e fb ff ff       	call   80101940 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 fe 27 00 00       	call   80104650 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 dd fb ff ff       	call   80101a40 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 32 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 f5 70 10 80       	push   $0x801070f5
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 be 76 10 80       	push   $0x801076be
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 7d fd ff ff       	call   80101c40 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101edf:	e9 5c fd ff ff       	jmp    80101c40 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 60 71 10 80       	push   $0x80107160
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 57 71 10 80       	push   $0x80107157
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 72 71 10 80       	push   $0x80107172
80101fcb:	68 80 a5 10 80       	push   $0x8010a580
80101fd0:	e8 8b 22 00 00       	call   80104260 <initlock>
  picenable(IRQ_IDE);
80101fd5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fdc:	e8 cf 12 00 00       	call   801032b0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe1:	58                   	pop    %eax
80101fe2:	a1 80 2d 11 80       	mov    0x80112d80,%eax
80101fe7:	5a                   	pop    %edx
80101fe8:	83 e8 01             	sub    $0x1,%eax
80101feb:	50                   	push   %eax
80101fec:	6a 0e                	push   $0xe
80101fee:	e8 bd 02 00 00       	call   801022b0 <ioapicenable>
80101ff3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffb:	90                   	nop
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x65>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x74>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x60>
      havedisk1 = 1;
8010202a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 a5 10 80       	push   $0x8010a580
8010205e:	e8 1d 22 00 00       	call   80104280 <acquire>
  if((b = idequeue) == 0){
80102063:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 0d 1f 00 00       	call   80103fa0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 4c fe ff ff       	call   80101ef0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 a5 10 80       	push   $0x8010a580
801020ac:	e8 af 23 00 00       	call   80104460 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 2d 21 00 00       	call   80104230 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 a5 10 80       	push   $0x8010a580
80102138:	e8 43 21 00 00       	call   80104280 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	53                   	push   %ebx
80102189:	e8 72 1c 00 00       	call   80103e00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010219b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021a6:	e9 b5 22 00 00       	jmp    80104460 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 37 fd ff ff       	call   80101ef0 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 76 71 10 80       	push   $0x80107176
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 a1 71 10 80       	push   $0x801071a1
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 8c 71 10 80       	push   $0x8010718c
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 a8 00 00 00    	je     801022a5 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021fe:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102205:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	56                   	push   %esi
8010220b:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102213:	00 00 00 
  return ioapic->data;
80102216:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010221c:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010221f:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102225:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102232:	89 f0                	mov    %esi,%eax
80102234:	c1 e8 10             	shr    $0x10,%eax
80102237:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010223d:	c1 e8 18             	shr    $0x18,%eax
80102240:	39 d0                	cmp    %edx,%eax
80102242:	74 16                	je     8010225a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 c0 71 10 80       	push   $0x801071c0
8010224c:	e8 0f e4 ff ff       	call   80100660 <cprintf>
80102251:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010225d:	ba 10 00 00 00       	mov    $0x10,%edx
80102262:	b8 20 00 00 00       	mov    $0x20,%eax
80102267:	89 f6                	mov    %esi,%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102270:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102272:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102278:	89 c3                	mov    %eax,%ebx
8010227a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102280:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102283:	89 59 10             	mov    %ebx,0x10(%ecx)
80102286:	8d 5a 01             	lea    0x1(%edx),%ebx
80102289:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102290:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102296:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229d:	75 d1                	jne    80102270 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022a2:	5b                   	pop    %ebx
801022a3:	5e                   	pop    %esi
801022a4:	5d                   	pop    %ebp
801022a5:	f3 c3                	repz ret 
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022b0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022b6:	55                   	push   %ebp
801022b7:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801022b9:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022be:	74 2b                	je     801022eb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022c6:	8d 50 20             	lea    0x20(%eax),%edx
801022c9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cd:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022cf:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022d8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022db:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022de:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e0:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022eb:	5d                   	pop    %ebp
801022ec:	c3                   	ret    
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 04             	sub    $0x4,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 70                	jne    80102372 <kfree+0x82>
80102302:	81 fb 28 55 11 80    	cmp    $0x80115528,%ebx
80102308:	72 68                	jb     80102372 <kfree+0x82>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 5b                	ja     80102372 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	83 ec 04             	sub    $0x4,%esp
8010231a:	68 00 10 00 00       	push   $0x1000
8010231f:	6a 01                	push   $0x1
80102321:	53                   	push   %ebx
80102322:	e8 89 21 00 00       	call   801044b0 <memset>

  if(kmem.use_lock)
80102327:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	85 d2                	test   %edx,%edx
80102332:	75 2c                	jne    80102360 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102334:	a1 98 26 11 80       	mov    0x80112698,%eax
80102339:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010233b:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102340:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102346:	85 c0                	test   %eax,%eax
80102348:	75 06                	jne    80102350 <kfree+0x60>
    release(&kmem.lock);
}
8010234a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234d:	c9                   	leave  
8010234e:	c3                   	ret    
8010234f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102350:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010235a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010235b:	e9 00 21 00 00       	jmp    80104460 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 60 26 11 80       	push   $0x80112660
80102368:	e8 13 1f 00 00       	call   80104280 <acquire>
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	eb c2                	jmp    80102334 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	68 f2 71 10 80       	push   $0x801071f2
8010237a:	e8 f1 df ff ff       	call   80100370 <panic>
8010237f:	90                   	nop

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102388:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102391:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102397:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010239d:	39 de                	cmp    %ebx,%esi
8010239f:	72 23                	jb     801023c4 <freerange+0x44>
801023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ae:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023b7:	50                   	push   %eax
801023b8:	e8 33 ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	39 f3                	cmp    %esi,%ebx
801023c2:	76 e4                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023c7:	5b                   	pop    %ebx
801023c8:	5e                   	pop    %esi
801023c9:	5d                   	pop    %ebp
801023ca:	c3                   	ret    
801023cb:	90                   	nop
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023d8:	83 ec 08             	sub    $0x8,%esp
801023db:	68 f8 71 10 80       	push   $0x801071f8
801023e0:	68 60 26 11 80       	push   $0x80112660
801023e5:	e8 76 1e 00 00       	call   80104260 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023f7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102400:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102406:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010240c:	39 de                	cmp    %ebx,%esi
8010240e:	72 1c                	jb     8010242c <kinit1+0x5c>
    kfree(p);
80102410:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102416:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102419:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010241f:	50                   	push   %eax
80102420:	e8 cb fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102425:	83 c4 10             	add    $0x10,%esp
80102428:	39 de                	cmp    %ebx,%esi
8010242a:	73 e4                	jae    80102410 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010242f:	5b                   	pop    %ebx
80102430:	5e                   	pop    %esi
80102431:	5d                   	pop    %ebp
80102432:	c3                   	ret    
80102433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102445:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102451:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245d:	39 de                	cmp    %ebx,%esi
8010245f:	72 23                	jb     80102484 <kinit2+0x44>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102468:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010246e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102477:	50                   	push   %eax
80102478:	e8 73 fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 e4                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102484:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010248b:	00 00 00 
}
8010248e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 94 26 11 80       	mov    0x80112694,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 1c                	je     801024d6 <kalloc+0x36>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 10                	je     801024d6 <kalloc+0x36>
    release(&kmem.lock);
801024c6:	83 ec 0c             	sub    $0xc,%esp
801024c9:	68 60 26 11 80       	push   $0x80112660
801024ce:	e8 8d 1f 00 00       	call   80104460 <release>
801024d3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024d6:	89 d8                	mov    %ebx,%eax
801024d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024db:	c9                   	leave  
801024dc:	c3                   	ret    
801024dd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 60 26 11 80       	push   $0x80112660
801024e8:	e8 93 1d 00 00       	call   80104280 <acquire>
  r = kmem.freelist;
801024ed:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024f3:	83 c4 10             	add    $0x10,%esp
801024f6:	a1 94 26 11 80       	mov    0x80112694,%eax
801024fb:	85 db                	test   %ebx,%ebx
801024fd:	75 bb                	jne    801024ba <kalloc+0x1a>
801024ff:	eb c1                	jmp    801024c2 <kalloc+0x22>
80102501:	66 90                	xchg   %ax,%ax
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102510:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102511:	ba 64 00 00 00       	mov    $0x64,%edx
80102516:	89 e5                	mov    %esp,%ebp
80102518:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102519:	a8 01                	test   $0x1,%al
8010251b:	0f 84 af 00 00 00    	je     801025d0 <kbdgetc+0xc0>
80102521:	ba 60 00 00 00       	mov    $0x60,%edx
80102526:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102527:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010252a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102530:	74 7e                	je     801025b0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102532:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010253a:	79 24                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010253c:	f6 c1 40             	test   $0x40,%cl
8010253f:	75 05                	jne    80102546 <kbdgetc+0x36>
80102541:	89 c2                	mov    %eax,%edx
80102543:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102546:	0f b6 82 20 73 10 80 	movzbl -0x7fef8ce0(%edx),%eax
8010254d:	83 c8 40             	or     $0x40,%eax
80102550:	0f b6 c0             	movzbl %al,%eax
80102553:	f7 d0                	not    %eax
80102555:	21 c8                	and    %ecx,%eax
80102557:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010255e:	5d                   	pop    %ebp
8010255f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102560:	f6 c1 40             	test   $0x40,%cl
80102563:	74 09                	je     8010256e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102568:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010256e:	0f b6 82 20 73 10 80 	movzbl -0x7fef8ce0(%edx),%eax
80102575:	09 c1                	or     %eax,%ecx
80102577:	0f b6 82 20 72 10 80 	movzbl -0x7fef8de0(%edx),%eax
8010257e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102580:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102582:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102588:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010258b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258e:	8b 04 85 00 72 10 80 	mov    -0x7fef8e00(,%eax,4),%eax
80102595:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102599:	74 c3                	je     8010255e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010259b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010259e:	83 fa 19             	cmp    $0x19,%edx
801025a1:	77 1d                	ja     801025c0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801025a3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
801025a7:	c3                   	ret    
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025b0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b2:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025c3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025c6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025c7:	83 f9 19             	cmp    $0x19,%ecx
801025ca:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d5:	5d                   	pop    %ebp
801025d6:	c3                   	ret    
801025d7:	89 f6                	mov    %esi,%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025e6:	68 10 25 10 80       	push   $0x80102510
801025eb:	e8 00 e2 ff ff       	call   801007f0 <consoleintr>
}
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 c8 00 00 00    	je     801026d8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102627:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010262a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102631:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102634:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102637:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010263e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102644:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010264b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102651:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102658:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010265e:	8b 50 30             	mov    0x30(%eax),%edx
80102661:	c1 ea 10             	shr    $0x10,%edx
80102664:	80 fa 03             	cmp    $0x3,%dl
80102667:	77 77                	ja     801026e0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102669:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102670:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102673:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102676:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102680:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102683:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102697:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026c6:	80 e6 10             	and    $0x10,%dh
801026c9:	75 f5                	jne    801026c0 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
801026ed:	e9 77 ff ff ff       	jmp    80102669 <lapicinit+0x69>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102705:	9c                   	pushf  
80102706:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102707:	f6 c4 02             	test   $0x2,%ah
8010270a:	74 12                	je     8010271e <cpunum+0x1e>
    static int n;
    if(n++ == 0)
8010270c:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102711:	8d 50 01             	lea    0x1(%eax),%edx
80102714:	85 c0                	test   %eax,%eax
80102716:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010271c:	74 4d                	je     8010276b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
8010271e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102723:	85 c0                	test   %eax,%eax
80102725:	74 60                	je     80102787 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
80102727:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010272a:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102730:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102733:	85 f6                	test   %esi,%esi
80102735:	7e 59                	jle    80102790 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102737:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
8010273e:	39 c3                	cmp    %eax,%ebx
80102740:	74 45                	je     80102787 <cpunum+0x87>
80102742:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
80102747:	31 c0                	xor    %eax,%eax
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102750:	83 c0 01             	add    $0x1,%eax
80102753:	39 f0                	cmp    %esi,%eax
80102755:	74 39                	je     80102790 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102757:	0f b6 0a             	movzbl (%edx),%ecx
8010275a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102760:	39 cb                	cmp    %ecx,%ebx
80102762:	75 ec                	jne    80102750 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102767:	5b                   	pop    %ebx
80102768:	5e                   	pop    %esi
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010276b:	83 ec 08             	sub    $0x8,%esp
8010276e:	ff 75 04             	pushl  0x4(%ebp)
80102771:	68 20 74 10 80       	push   $0x80107420
80102776:	e8 e5 de ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010277b:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102780:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102783:	85 c0                	test   %eax,%eax
80102785:	75 a0                	jne    80102727 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102787:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010278a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010278c:	5b                   	pop    %ebx
8010278d:	5e                   	pop    %esi
8010278e:	5d                   	pop    %ebp
8010278f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 4c 74 10 80       	push   $0x8010744c
80102798:	e8 d3 db ff ff       	call   80100370 <panic>
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027a0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0d                	je     801027b9 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
}
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	53                   	push   %ebx
801027de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027e4:	ee                   	out    %al,(%dx)
801027e5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ea:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027f0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027fd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102800:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102803:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102805:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102808:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102813:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102819:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102823:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102826:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102829:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102830:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102833:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102836:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102845:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102848:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102851:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010285a:	5b                   	pop    %ebx
8010285b:	5d                   	pop    %ebp
8010285c:	c3                   	ret    
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102860:	55                   	push   %ebp
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	b8 0b 00 00 00       	mov    $0xb,%eax
8010286b:	89 e5                	mov    %esp,%ebp
8010286d:	57                   	push   %edi
8010286e:	56                   	push   %esi
8010286f:	53                   	push   %ebx
80102870:	83 ec 4c             	sub    $0x4c,%esp
80102873:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	ba 71 00 00 00       	mov    $0x71,%edx
80102879:	ec                   	in     (%dx),%al
8010287a:	83 e0 04             	and    $0x4,%eax
8010287d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102880:	31 db                	xor    %ebx,%ebx
80102882:	88 45 b7             	mov    %al,-0x49(%ebp)
80102885:	bf 70 00 00 00       	mov    $0x70,%edi
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102890:	89 d8                	mov    %ebx,%eax
80102892:	89 fa                	mov    %edi,%edx
80102894:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102895:	b9 71 00 00 00       	mov    $0x71,%ecx
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010289d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a0:	89 fa                	mov    %edi,%edx
801028a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028a5:	b8 02 00 00 00       	mov    $0x2,%eax
801028aa:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ab:	89 ca                	mov    %ecx,%edx
801028ad:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028ae:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b1:	89 fa                	mov    %edi,%edx
801028b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028b6:	b8 04 00 00 00       	mov    $0x4,%eax
801028bb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bc:	89 ca                	mov    %ecx,%edx
801028be:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028bf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c2:	89 fa                	mov    %edi,%edx
801028c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c7:	b8 07 00 00 00       	mov    $0x7,%eax
801028cc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cd:	89 ca                	mov    %ecx,%edx
801028cf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028d0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d3:	89 fa                	mov    %edi,%edx
801028d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d8:	b8 08 00 00 00       	mov    $0x8,%eax
801028dd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028de:	89 ca                	mov    %ecx,%edx
801028e0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028e1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e4:	89 fa                	mov    %edi,%edx
801028e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028e9:	b8 09 00 00 00       	mov    $0x9,%eax
801028ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ef:	89 ca                	mov    %ecx,%edx
801028f1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028f2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	89 fa                	mov    %edi,%edx
801028f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028fa:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ff:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	89 ca                	mov    %ecx,%edx
80102902:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102903:	84 c0                	test   %al,%al
80102905:	78 89                	js     80102890 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102907:	89 d8                	mov    %ebx,%eax
80102909:	89 fa                	mov    %edi,%edx
8010290b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010290f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 fa                	mov    %edi,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102920:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 fa                	mov    %edi,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102931:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 fa                	mov    %edi,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102942:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 fa                	mov    %edi,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102953:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 fa                	mov    %edi,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102964:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	56                   	push   %esi
80102973:	50                   	push   %eax
80102974:	e8 87 1b 00 00       	call   80104500 <memcmp>
80102979:	83 c4 10             	add    $0x10,%esp
8010297c:	85 c0                	test   %eax,%eax
8010297e:	0f 85 0c ff ff ff    	jne    80102890 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102984:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102988:	75 78                	jne    80102a02 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010298d:	89 c2                	mov    %eax,%edx
8010298f:	83 e0 0f             	and    $0xf,%eax
80102992:	c1 ea 04             	shr    $0x4,%edx
80102995:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102998:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010299e:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a1:	89 c2                	mov    %eax,%edx
801029a3:	83 e0 0f             	and    $0xf,%eax
801029a6:	c1 ea 04             	shr    $0x4,%edx
801029a9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ac:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029af:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b5:	89 c2                	mov    %eax,%edx
801029b7:	83 e0 0f             	and    $0xf,%eax
801029ba:	c1 ea 04             	shr    $0x4,%edx
801029bd:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029c9:	89 c2                	mov    %eax,%edx
801029cb:	83 e0 0f             	and    $0xf,%eax
801029ce:	c1 ea 04             	shr    $0x4,%edx
801029d1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029da:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029dd:	89 c2                	mov    %eax,%edx
801029df:	83 e0 0f             	and    $0xf,%eax
801029e2:	c1 ea 04             	shr    $0x4,%edx
801029e5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029e8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f1:	89 c2                	mov    %eax,%edx
801029f3:	83 e0 0f             	and    $0xf,%eax
801029f6:	c1 ea 04             	shr    $0x4,%edx
801029f9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029fc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a02:	8b 75 08             	mov    0x8(%ebp),%esi
80102a05:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a08:	89 06                	mov    %eax,(%esi)
80102a0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a0d:	89 46 04             	mov    %eax,0x4(%esi)
80102a10:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a13:	89 46 08             	mov    %eax,0x8(%esi)
80102a16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a19:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a1f:	89 46 10             	mov    %eax,0x10(%esi)
80102a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a25:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a28:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a32:	5b                   	pop    %ebx
80102a33:	5e                   	pop    %esi
80102a34:	5f                   	pop    %edi
80102a35:	5d                   	pop    %ebp
80102a36:	c3                   	ret    
80102a37:	66 90                	xchg   %ax,%ax
80102a39:	66 90                	xchg   %ax,%ax
80102a3b:	66 90                	xchg   %ax,%ax
80102a3d:	66 90                	xchg   %ax,%ax
80102a3f:	90                   	nop

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 85 00 00 00    	jle    80102ad3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
80102a54:	31 db                	xor    %ebx,%ebx
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a84:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 b7 1a 00 00       	call   80104560 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	f3 c3                	repz ret 
80102ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	53                   	push   %ebx
80102ae4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae7:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102aed:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102af3:	e8 d8 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af8:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102afe:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b01:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b03:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b05:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b08:	7e 1f                	jle    80102b29 <write_head+0x49>
80102b0a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102b11:	31 d2                	xor    %edx,%edx
80102b13:	90                   	nop
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b18:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102b1e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102b22:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b25:	39 c2                	cmp    %eax,%edx
80102b27:	75 ef                	jne    80102b18 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b29:	83 ec 0c             	sub    $0xc,%esp
80102b2c:	53                   	push   %ebx
80102b2d:	e8 6e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b32:	89 1c 24             	mov    %ebx,(%esp)
80102b35:	e8 a6 d6 ff ff       	call   801001e0 <brelse>
}
80102b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b3d:	c9                   	leave  
80102b3e:	c3                   	ret    
80102b3f:	90                   	nop

80102b40 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b4a:	68 5c 74 10 80       	push   $0x8010745c
80102b4f:	68 a0 26 11 80       	push   $0x801126a0
80102b54:	e8 07 17 00 00       	call   80104260 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 5b e8 ff ff       	call   801013c0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b6c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b72:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b78:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b85:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b8d:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b9c:	31 d2                	xor    %edx,%edx
80102b9e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 da                	cmp    %ebx,%edx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd1:	c9                   	leave  
80102bd2:	c3                   	ret    
80102bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 a0 26 11 80       	push   $0x801126a0
80102beb:	e8 90 16 00 00       	call   80104280 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 a0 26 11 80       	push   $0x801126a0
80102c00:	68 a0 26 11 80       	push   $0x801126a0
80102c05:	e8 f6 11 00 00       	call   80103e00 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c0d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c1b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c32:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c37:	68 a0 26 11 80       	push   $0x801126a0
80102c3c:	e8 1f 18 00 00       	call   80104460 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 a0 26 11 80       	push   $0x801126a0
80102c5e:	e8 1d 16 00 00       	call   80104280 <acquire>
  log.outstanding -= 1;
80102c63:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c68:	8b 1d e0 26 11 80    	mov    0x801126e0,%ebx
80102c6e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c71:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c74:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c76:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c7b:	0f 85 23 01 00 00    	jne    80102da4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c81:	85 c0                	test   %eax,%eax
80102c83:	0f 85 f7 00 00 00    	jne    80102d80 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c89:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c8c:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c93:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c96:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c98:	68 a0 26 11 80       	push   $0x801126a0
80102c9d:	e8 be 17 00 00       	call   80104460 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca2:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ca8:	83 c4 10             	add    $0x10,%esp
80102cab:	85 c9                	test   %ecx,%ecx
80102cad:	0f 8e 8a 00 00 00    	jle    80102d3d <end_op+0xed>
80102cb3:	90                   	nop
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cbd:	83 ec 08             	sub    $0x8,%esp
80102cc0:	01 d8                	add    %ebx,%eax
80102cc2:	83 c0 01             	add    $0x1,%eax
80102cc5:	50                   	push   %eax
80102cc6:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ccc:	e8 ff d3 ff ff       	call   801000d0 <bread>
80102cd1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cd3:	58                   	pop    %eax
80102cd4:	5a                   	pop    %edx
80102cd5:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cdc:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ce5:	e8 e6 d3 ff ff       	call   801000d0 <bread>
80102cea:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cec:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cef:	83 c4 0c             	add    $0xc,%esp
80102cf2:	68 00 02 00 00       	push   $0x200
80102cf7:	50                   	push   %eax
80102cf8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cfb:	50                   	push   %eax
80102cfc:	e8 5f 18 00 00       	call   80104560 <memmove>
    bwrite(to);  // write the log
80102d01:	89 34 24             	mov    %esi,(%esp)
80102d04:	e8 97 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d09:	89 3c 24             	mov    %edi,(%esp)
80102d0c:	e8 cf d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d11:	89 34 24             	mov    %esi,(%esp)
80102d14:	e8 c7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d22:	7c 94                	jl     80102cb8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d24:	e8 b7 fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d29:	e8 12 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d2e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d35:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d38:	e8 a3 fd ff ff       	call   80102ae0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d3d:	83 ec 0c             	sub    $0xc,%esp
80102d40:	68 a0 26 11 80       	push   $0x801126a0
80102d45:	e8 36 15 00 00       	call   80104280 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d4a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d51:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d58:	00 00 00 
    wakeup(&log);
80102d5b:	e8 40 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102d60:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d67:	e8 f4 16 00 00       	call   80104460 <release>
80102d6c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d72:	5b                   	pop    %ebx
80102d73:	5e                   	pop    %esi
80102d74:	5f                   	pop    %edi
80102d75:	5d                   	pop    %ebp
80102d76:	c3                   	ret    
80102d77:	89 f6                	mov    %esi,%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	68 a0 26 11 80       	push   $0x801126a0
80102d88:	e8 13 12 00 00       	call   80103fa0 <wakeup>
  }
  release(&log.lock);
80102d8d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d94:	e8 c7 16 00 00       	call   80104460 <release>
80102d99:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9f:	5b                   	pop    %ebx
80102da0:	5e                   	pop    %esi
80102da1:	5f                   	pop    %edi
80102da2:	5d                   	pop    %ebp
80102da3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102da4:	83 ec 0c             	sub    $0xc,%esp
80102da7:	68 60 74 10 80       	push   $0x80107460
80102dac:	e8 bf d5 ff ff       	call   80100370 <panic>
80102db1:	eb 0d                	jmp    80102dc0 <log_write>
80102db3:	90                   	nop
80102db4:	90                   	nop
80102db5:	90                   	nop
80102db6:	90                   	nop
80102db7:	90                   	nop
80102db8:	90                   	nop
80102db9:	90                   	nop
80102dba:	90                   	nop
80102dbb:	90                   	nop
80102dbc:	90                   	nop
80102dbd:	90                   	nop
80102dbe:	90                   	nop
80102dbf:	90                   	nop

80102dc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dd0:	83 fa 1d             	cmp    $0x1d,%edx
80102dd3:	0f 8f 97 00 00 00    	jg     80102e70 <log_write+0xb0>
80102dd9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102dde:	83 e8 01             	sub    $0x1,%eax
80102de1:	39 c2                	cmp    %eax,%edx
80102de3:	0f 8d 87 00 00 00    	jge    80102e70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102de9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dee:	85 c0                	test   %eax,%eax
80102df0:	0f 8e 87 00 00 00    	jle    80102e7d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102df6:	83 ec 0c             	sub    $0xc,%esp
80102df9:	68 a0 26 11 80       	push   $0x801126a0
80102dfe:	e8 7d 14 00 00       	call   80104280 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e03:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e09:	83 c4 10             	add    $0x10,%esp
80102e0c:	83 fa 00             	cmp    $0x0,%edx
80102e0f:	7e 50                	jle    80102e61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e11:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e14:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e16:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102e1c:	75 0b                	jne    80102e29 <log_write+0x69>
80102e1e:	eb 38                	jmp    80102e58 <log_write+0x98>
80102e20:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102e27:	74 2f                	je     80102e58 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e29:	83 c0 01             	add    $0x1,%eax
80102e2c:	39 d0                	cmp    %edx,%eax
80102e2e:	75 f0                	jne    80102e20 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e30:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e37:	83 c2 01             	add    $0x1,%edx
80102e3a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e43:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e4d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e4e:	e9 0d 16 00 00       	jmp    80104460 <release>
80102e53:	90                   	nop
80102e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e58:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102e5f:	eb df                	jmp    80102e40 <log_write+0x80>
80102e61:	8b 43 08             	mov    0x8(%ebx),%eax
80102e64:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e69:	75 d5                	jne    80102e40 <log_write+0x80>
80102e6b:	eb ca                	jmp    80102e37 <log_write+0x77>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	68 6f 74 10 80       	push   $0x8010746f
80102e78:	e8 f3 d4 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e7d:	83 ec 0c             	sub    $0xc,%esp
80102e80:	68 85 74 10 80       	push   $0x80107485
80102e85:	e8 e6 d4 ff ff       	call   80100370 <panic>
80102e8a:	66 90                	xchg   %ax,%ax
80102e8c:	66 90                	xchg   %ax,%ax
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e96:	e8 65 f8 ff ff       	call   80102700 <cpunum>
80102e9b:	83 ec 08             	sub    $0x8,%esp
80102e9e:	50                   	push   %eax
80102e9f:	68 a0 74 10 80       	push   $0x801074a0
80102ea4:	e8 b7 d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea9:	e8 f2 28 00 00       	call   801057a0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102eae:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80102eba:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102ec1:	e8 5a 0c 00 00       	call   80103b20 <scheduler>
80102ec6:	8d 76 00             	lea    0x0(%esi),%esi
80102ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ed0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ed6:	e8 d5 3a 00 00       	call   801069b0 <switchkvm>
  seginit();
80102edb:	e8 f0 38 00 00       	call   801067d0 <seginit>
  lapicinit();
80102ee0:	e8 1b f7 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102ee5:	e8 a6 ff ff ff       	call   80102e90 <mpmain>
80102eea:	66 90                	xchg   %ax,%ax
80102eec:	66 90                	xchg   %ax,%ax
80102eee:	66 90                	xchg   %ax,%ax

80102ef0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ef0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ef4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ef7:	ff 71 fc             	pushl  -0x4(%ecx)
80102efa:	55                   	push   %ebp
80102efb:	89 e5                	mov    %esp,%ebp
80102efd:	53                   	push   %ebx
80102efe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eff:	83 ec 08             	sub    $0x8,%esp
80102f02:	68 00 00 40 80       	push   $0x80400000
80102f07:	68 28 55 11 80       	push   $0x80115528
80102f0c:	e8 bf f4 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102f11:	e8 7a 3a 00 00       	call   80106990 <kvmalloc>
  mpinit();        // detect other processors
80102f16:	e8 b5 01 00 00       	call   801030d0 <mpinit>
  lapicinit();     // interrupt controller
80102f1b:	e8 e0 f6 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102f20:	e8 ab 38 00 00       	call   801067d0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102f25:	e8 d6 f7 ff ff       	call   80102700 <cpunum>
80102f2a:	5a                   	pop    %edx
80102f2b:	59                   	pop    %ecx
80102f2c:	50                   	push   %eax
80102f2d:	68 b1 74 10 80       	push   $0x801074b1
80102f32:	e8 29 d7 ff ff       	call   80100660 <cprintf>
  picinit();       // another interrupt controller
80102f37:	e8 a4 03 00 00       	call   801032e0 <picinit>
  ioapicinit();    // another interrupt controller
80102f3c:	e8 af f2 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102f41:	e8 5a da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f46:	e8 55 2b 00 00       	call   80105aa0 <uartinit>
  pinit();         // process table
80102f4b:	e8 30 09 00 00       	call   80103880 <pinit>
  tvinit();        // trap vectors
80102f50:	e8 ab 27 00 00       	call   80105700 <tvinit>
  binit();         // buffer cache
80102f55:	e8 e6 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f5a:	e8 01 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk
80102f5f:	e8 5c f0 ff ff       	call   80101fc0 <ideinit>
  if(!ismp)
80102f64:	8b 1d 84 27 11 80    	mov    0x80112784,%ebx
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	85 db                	test   %ebx,%ebx
80102f6f:	0f 84 ca 00 00 00    	je     8010303f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f75:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102f78:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f7d:	68 8a 00 00 00       	push   $0x8a
80102f82:	68 90 a4 10 80       	push   $0x8010a490
80102f87:	68 00 70 00 80       	push   $0x80007000
80102f8c:	e8 cf 15 00 00       	call   80104560 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f91:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f98:	00 00 00 
80102f9b:	83 c4 10             	add    $0x10,%esp
80102f9e:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fa3:	39 d8                	cmp    %ebx,%eax
80102fa5:	76 7c                	jbe    80103023 <main+0x133>
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80102fb0:	e8 4b f7 ff ff       	call   80102700 <cpunum>
80102fb5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102fbb:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fc0:	39 c3                	cmp    %eax,%ebx
80102fc2:	74 46                	je     8010300a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fc4:	e8 d7 f4 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fc9:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fcc:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fd1:	c7 05 f8 6f 00 80 d0 	movl   $0x80102ed0,0x80006ff8
80102fd8:	2e 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fdb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fe0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fe7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102fea:	68 00 70 00 00       	push   $0x7000
80102fef:	0f b6 03             	movzbl (%ebx),%eax
80102ff2:	50                   	push   %eax
80102ff3:	e8 d8 f7 ff ff       	call   801027d0 <lapicstartap>
80102ff8:	83 c4 10             	add    $0x10,%esp
80102ffb:	90                   	nop
80102ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103000:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	74 f6                	je     80103000 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010300a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80103011:	00 00 00 
80103014:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010301a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010301f:	39 c3                	cmp    %eax,%ebx
80103021:	72 8d                	jb     80102fb0 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103023:	83 ec 08             	sub    $0x8,%esp
80103026:	68 00 00 00 8e       	push   $0x8e000000
8010302b:	68 00 00 40 80       	push   $0x80400000
80103030:	e8 0b f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80103035:	e8 66 08 00 00       	call   801038a0 <userinit>
  mpmain();        // finish this processor's setup
8010303a:	e8 51 fe ff ff       	call   80102e90 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
8010303f:	e8 5c 26 00 00       	call   801056a0 <timerinit>
80103044:	e9 2c ff ff ff       	jmp    80102f75 <main+0x85>
80103049:	66 90                	xchg   %ax,%ax
8010304b:	66 90                	xchg   %ax,%ax
8010304d:	66 90                	xchg   %ax,%ax
8010304f:	90                   	nop

80103050 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103055:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010305c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103062:	39 de                	cmp    %ebx,%esi
80103064:	73 48                	jae    801030ae <mpsearch1+0x5e>
80103066:	8d 76 00             	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103070:	83 ec 04             	sub    $0x4,%esp
80103073:	8d 7e 10             	lea    0x10(%esi),%edi
80103076:	6a 04                	push   $0x4
80103078:	68 c8 74 10 80       	push   $0x801074c8
8010307d:	56                   	push   %esi
8010307e:	e8 7d 14 00 00       	call   80104500 <memcmp>
80103083:	83 c4 10             	add    $0x10,%esp
80103086:	85 c0                	test   %eax,%eax
80103088:	75 1e                	jne    801030a8 <mpsearch1+0x58>
8010308a:	8d 7e 10             	lea    0x10(%esi),%edi
8010308d:	89 f2                	mov    %esi,%edx
8010308f:	31 c9                	xor    %ecx,%ecx
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103098:	0f b6 02             	movzbl (%edx),%eax
8010309b:	83 c2 01             	add    $0x1,%edx
8010309e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	39 fa                	cmp    %edi,%edx
801030a2:	75 f4                	jne    80103098 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030a4:	84 c9                	test   %cl,%cl
801030a6:	74 10                	je     801030b8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030a8:	39 fb                	cmp    %edi,%ebx
801030aa:	89 fe                	mov    %edi,%esi
801030ac:	77 c2                	ja     80103070 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801030ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801030b1:	31 c0                	xor    %eax,%eax
}
801030b3:	5b                   	pop    %ebx
801030b4:	5e                   	pop    %esi
801030b5:	5f                   	pop    %edi
801030b6:	5d                   	pop    %ebp
801030b7:	c3                   	ret    
801030b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bb:	89 f0                	mov    %esi,%eax
801030bd:	5b                   	pop    %ebx
801030be:	5e                   	pop    %esi
801030bf:	5f                   	pop    %edi
801030c0:	5d                   	pop    %ebp
801030c1:	c3                   	ret    
801030c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030e7:	c1 e0 08             	shl    $0x8,%eax
801030ea:	09 d0                	or     %edx,%eax
801030ec:	c1 e0 04             	shl    $0x4,%eax
801030ef:	85 c0                	test   %eax,%eax
801030f1:	75 1b                	jne    8010310e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103101:	c1 e0 08             	shl    $0x8,%eax
80103104:	09 d0                	or     %edx,%eax
80103106:	c1 e0 0a             	shl    $0xa,%eax
80103109:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010310e:	ba 00 04 00 00       	mov    $0x400,%edx
80103113:	e8 38 ff ff ff       	call   80103050 <mpsearch1>
80103118:	85 c0                	test   %eax,%eax
8010311a:	89 c6                	mov    %eax,%esi
8010311c:	0f 84 66 01 00 00    	je     80103288 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103122:	8b 5e 04             	mov    0x4(%esi),%ebx
80103125:	85 db                	test   %ebx,%ebx
80103127:	0f 84 d6 00 00 00    	je     80103203 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010312d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103133:	83 ec 04             	sub    $0x4,%esp
80103136:	6a 04                	push   $0x4
80103138:	68 cd 74 10 80       	push   $0x801074cd
8010313d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010313e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103141:	e8 ba 13 00 00       	call   80104500 <memcmp>
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	85 c0                	test   %eax,%eax
8010314b:	0f 85 b2 00 00 00    	jne    80103203 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103151:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103158:	3c 01                	cmp    $0x1,%al
8010315a:	74 08                	je     80103164 <mpinit+0x94>
8010315c:	3c 04                	cmp    $0x4,%al
8010315e:	0f 85 9f 00 00 00    	jne    80103203 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103164:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010316b:	85 ff                	test   %edi,%edi
8010316d:	74 1e                	je     8010318d <mpinit+0xbd>
8010316f:	31 d2                	xor    %edx,%edx
80103171:	31 c0                	xor    %eax,%eax
80103173:	90                   	nop
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103178:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010317f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103180:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103183:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103185:	39 c7                	cmp    %eax,%edi
80103187:	75 ef                	jne    80103178 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103189:	84 d2                	test   %dl,%dl
8010318b:	75 76                	jne    80103203 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010318d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103190:	85 ff                	test   %edi,%edi
80103192:	74 6f                	je     80103203 <mpinit+0x133>
    return;
  ismp = 1;
80103194:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010319b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010319e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031a4:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031a9:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
801031b0:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801031b6:	01 f9                	add    %edi,%ecx
801031b8:	39 c8                	cmp    %ecx,%eax
801031ba:	0f 83 a0 00 00 00    	jae    80103260 <mpinit+0x190>
    switch(*p){
801031c0:	80 38 04             	cmpb   $0x4,(%eax)
801031c3:	0f 87 87 00 00 00    	ja     80103250 <mpinit+0x180>
801031c9:	0f b6 10             	movzbl (%eax),%edx
801031cc:	ff 24 95 d4 74 10 80 	jmp    *-0x7fef8b2c(,%edx,4)
801031d3:	90                   	nop
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031d8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031db:	39 c1                	cmp    %eax,%ecx
801031dd:	77 e1                	ja     801031c0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801031df:	a1 84 27 11 80       	mov    0x80112784,%eax
801031e4:	85 c0                	test   %eax,%eax
801031e6:	75 78                	jne    80103260 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031e8:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
801031ef:	00 00 00 
    lapic = 0;
801031f2:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801031f9:	00 00 00 
    ioapicid = 0;
801031fc:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103206:	5b                   	pop    %ebx
80103207:	5e                   	pop    %esi
80103208:	5f                   	pop    %edi
80103209:	5d                   	pop    %ebp
8010320a:	c3                   	ret    
8010320b:	90                   	nop
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103210:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
80103216:	83 fa 07             	cmp    $0x7,%edx
80103219:	7f 19                	jg     80103234 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010321b:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
8010321f:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103225:	83 c2 01             	add    $0x1,%edx
80103228:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010322e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103234:	83 c0 14             	add    $0x14,%eax
      continue;
80103237:	eb a2                	jmp    801031db <mpinit+0x10b>
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103240:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103244:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103247:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010324d:	eb 8c                	jmp    801031db <mpinit+0x10b>
8010324f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103250:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103257:	00 00 00 
      break;
8010325a:	e9 7c ff ff ff       	jmp    801031db <mpinit+0x10b>
8010325f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103260:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103264:	74 9d                	je     80103203 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103266:	ba 22 00 00 00       	mov    $0x22,%edx
8010326b:	b8 70 00 00 00       	mov    $0x70,%eax
80103270:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103271:	ba 23 00 00 00       	mov    $0x23,%edx
80103276:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103277:	83 c8 01             	or     $0x1,%eax
8010327a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010327b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327e:	5b                   	pop    %ebx
8010327f:	5e                   	pop    %esi
80103280:	5f                   	pop    %edi
80103281:	5d                   	pop    %ebp
80103282:	c3                   	ret    
80103283:	90                   	nop
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103288:	ba 00 00 01 00       	mov    $0x10000,%edx
8010328d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103292:	e8 b9 fd ff ff       	call   80103050 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103297:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103299:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010329b:	0f 85 81 fe ff ff    	jne    80103122 <mpinit+0x52>
801032a1:	e9 5d ff ff ff       	jmp    80103203 <mpinit+0x133>
801032a6:	66 90                	xchg   %ax,%ax
801032a8:	66 90                	xchg   %ax,%ax
801032aa:	66 90                	xchg   %ax,%ax
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032b0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801032b1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801032b6:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032bb:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
801032bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801032c0:	d3 c0                	rol    %cl,%eax
801032c2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801032c9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801032cf:	ee                   	out    %al,(%dx)
801032d0:	ba a1 00 00 00       	mov    $0xa1,%edx
801032d5:	66 c1 e8 08          	shr    $0x8,%ax
801032d9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032da:	5d                   	pop    %ebp
801032db:	c3                   	ret    
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032e0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032e0:	55                   	push   %ebp
801032e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032e6:	89 e5                	mov    %esp,%ebp
801032e8:	57                   	push   %edi
801032e9:	56                   	push   %esi
801032ea:	53                   	push   %ebx
801032eb:	bb 21 00 00 00       	mov    $0x21,%ebx
801032f0:	89 da                	mov    %ebx,%edx
801032f2:	ee                   	out    %al,(%dx)
801032f3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032f8:	89 ca                	mov    %ecx,%edx
801032fa:	ee                   	out    %al,(%dx)
801032fb:	bf 11 00 00 00       	mov    $0x11,%edi
80103300:	be 20 00 00 00       	mov    $0x20,%esi
80103305:	89 f8                	mov    %edi,%eax
80103307:	89 f2                	mov    %esi,%edx
80103309:	ee                   	out    %al,(%dx)
8010330a:	b8 20 00 00 00       	mov    $0x20,%eax
8010330f:	89 da                	mov    %ebx,%edx
80103311:	ee                   	out    %al,(%dx)
80103312:	b8 04 00 00 00       	mov    $0x4,%eax
80103317:	ee                   	out    %al,(%dx)
80103318:	b8 03 00 00 00       	mov    $0x3,%eax
8010331d:	ee                   	out    %al,(%dx)
8010331e:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103323:	89 f8                	mov    %edi,%eax
80103325:	89 da                	mov    %ebx,%edx
80103327:	ee                   	out    %al,(%dx)
80103328:	b8 28 00 00 00       	mov    $0x28,%eax
8010332d:	89 ca                	mov    %ecx,%edx
8010332f:	ee                   	out    %al,(%dx)
80103330:	b8 02 00 00 00       	mov    $0x2,%eax
80103335:	ee                   	out    %al,(%dx)
80103336:	b8 03 00 00 00       	mov    $0x3,%eax
8010333b:	ee                   	out    %al,(%dx)
8010333c:	bf 68 00 00 00       	mov    $0x68,%edi
80103341:	89 f2                	mov    %esi,%edx
80103343:	89 f8                	mov    %edi,%eax
80103345:	ee                   	out    %al,(%dx)
80103346:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010334b:	89 c8                	mov    %ecx,%eax
8010334d:	ee                   	out    %al,(%dx)
8010334e:	89 f8                	mov    %edi,%eax
80103350:	89 da                	mov    %ebx,%edx
80103352:	ee                   	out    %al,(%dx)
80103353:	89 c8                	mov    %ecx,%eax
80103355:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103356:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010335d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103361:	74 10                	je     80103373 <picinit+0x93>
80103363:	ba 21 00 00 00       	mov    $0x21,%edx
80103368:	ee                   	out    %al,(%dx)
80103369:	ba a1 00 00 00       	mov    $0xa1,%edx
8010336e:	66 c1 e8 08          	shr    $0x8,%ax
80103372:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103373:	5b                   	pop    %ebx
80103374:	5e                   	pop    %esi
80103375:	5f                   	pop    %edi
80103376:	5d                   	pop    %ebp
80103377:	c3                   	ret    
80103378:	66 90                	xchg   %ax,%ax
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	8b 75 08             	mov    0x8(%ebp),%esi
8010338c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010338f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103395:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010339b:	e8 e0 d9 ff ff       	call   80100d80 <filealloc>
801033a0:	85 c0                	test   %eax,%eax
801033a2:	89 06                	mov    %eax,(%esi)
801033a4:	0f 84 a8 00 00 00    	je     80103452 <pipealloc+0xd2>
801033aa:	e8 d1 d9 ff ff       	call   80100d80 <filealloc>
801033af:	85 c0                	test   %eax,%eax
801033b1:	89 03                	mov    %eax,(%ebx)
801033b3:	0f 84 87 00 00 00    	je     80103440 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033b9:	e8 e2 f0 ff ff       	call   801024a0 <kalloc>
801033be:	85 c0                	test   %eax,%eax
801033c0:	89 c7                	mov    %eax,%edi
801033c2:	0f 84 b0 00 00 00    	je     80103478 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033c8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801033cb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033d2:	00 00 00 
  p->writeopen = 1;
801033d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033dc:	00 00 00 
  p->nwrite = 0;
801033df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033e6:	00 00 00 
  p->nread = 0;
801033e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033f0:	00 00 00 
  initlock(&p->lock, "pipe");
801033f3:	68 e8 74 10 80       	push   $0x801074e8
801033f8:	50                   	push   %eax
801033f9:	e8 62 0e 00 00       	call   80104260 <initlock>
  (*f0)->type = FD_PIPE;
801033fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103400:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103403:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103409:	8b 06                	mov    (%esi),%eax
8010340b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010340f:	8b 06                	mov    (%esi),%eax
80103411:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103415:	8b 06                	mov    (%esi),%eax
80103417:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010341a:	8b 03                	mov    (%ebx),%eax
8010341c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103422:	8b 03                	mov    (%ebx),%eax
80103424:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103428:	8b 03                	mov    (%ebx),%eax
8010342a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010342e:	8b 03                	mov    (%ebx),%eax
80103430:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103436:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103438:	5b                   	pop    %ebx
80103439:	5e                   	pop    %esi
8010343a:	5f                   	pop    %edi
8010343b:	5d                   	pop    %ebp
8010343c:	c3                   	ret    
8010343d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103440:	8b 06                	mov    (%esi),%eax
80103442:	85 c0                	test   %eax,%eax
80103444:	74 1e                	je     80103464 <pipealloc+0xe4>
    fileclose(*f0);
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	50                   	push   %eax
8010344a:	e8 f1 d9 ff ff       	call   80100e40 <fileclose>
8010344f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103452:	8b 03                	mov    (%ebx),%eax
80103454:	85 c0                	test   %eax,%eax
80103456:	74 0c                	je     80103464 <pipealloc+0xe4>
    fileclose(*f1);
80103458:	83 ec 0c             	sub    $0xc,%esp
8010345b:	50                   	push   %eax
8010345c:	e8 df d9 ff ff       	call   80100e40 <fileclose>
80103461:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103464:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010346c:	5b                   	pop    %ebx
8010346d:	5e                   	pop    %esi
8010346e:	5f                   	pop    %edi
8010346f:	5d                   	pop    %ebp
80103470:	c3                   	ret    
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103478:	8b 06                	mov    (%esi),%eax
8010347a:	85 c0                	test   %eax,%eax
8010347c:	75 c8                	jne    80103446 <pipealloc+0xc6>
8010347e:	eb d2                	jmp    80103452 <pipealloc+0xd2>

80103480 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	56                   	push   %esi
80103484:	53                   	push   %ebx
80103485:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103488:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	53                   	push   %ebx
8010348f:	e8 ec 0d 00 00       	call   80104280 <acquire>
  if(writable){
80103494:	83 c4 10             	add    $0x10,%esp
80103497:	85 f6                	test   %esi,%esi
80103499:	74 45                	je     801034e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010349b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034a1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801034a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034ab:	00 00 00 
    wakeup(&p->nread);
801034ae:	50                   	push   %eax
801034af:	e8 ec 0a 00 00       	call   80103fa0 <wakeup>
801034b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034bd:	85 d2                	test   %edx,%edx
801034bf:	75 0a                	jne    801034cb <pipeclose+0x4b>
801034c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034c7:	85 c0                	test   %eax,%eax
801034c9:	74 35                	je     80103500 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d1:	5b                   	pop    %ebx
801034d2:	5e                   	pop    %esi
801034d3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034d4:	e9 87 0f 00 00       	jmp    80104460 <release>
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034e6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034f0:	00 00 00 
    wakeup(&p->nwrite);
801034f3:	50                   	push   %eax
801034f4:	e8 a7 0a 00 00       	call   80103fa0 <wakeup>
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	eb b9                	jmp    801034b7 <pipeclose+0x37>
801034fe:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 57 0f 00 00       	call   80104460 <release>
    kfree((char*)p);
80103509:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010350c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010350f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103512:	5b                   	pop    %ebx
80103513:	5e                   	pop    %esi
80103514:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103515:	e9 d6 ed ff ff       	jmp    801022f0 <kfree>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103520 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 28             	sub    $0x28,%esp
80103529:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010352c:	57                   	push   %edi
8010352d:	e8 4e 0d 00 00       	call   80104280 <acquire>
  for(i = 0; i < n; i++){
80103532:	8b 45 10             	mov    0x10(%ebp),%eax
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	85 c0                	test   %eax,%eax
8010353a:	0f 8e c6 00 00 00    	jle    80103606 <pipewrite+0xe6>
80103540:	8b 45 0c             	mov    0xc(%ebp),%eax
80103543:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103549:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010354f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103558:	03 45 10             	add    0x10(%ebp),%eax
8010355b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010355e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103564:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010356a:	39 d1                	cmp    %edx,%ecx
8010356c:	0f 85 cf 00 00 00    	jne    80103641 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103572:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103578:	85 d2                	test   %edx,%edx
8010357a:	0f 84 a8 00 00 00    	je     80103628 <pipewrite+0x108>
80103580:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103587:	8b 42 24             	mov    0x24(%edx),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	74 25                	je     801035b3 <pipewrite+0x93>
8010358e:	e9 95 00 00 00       	jmp    80103628 <pipewrite+0x108>
80103593:	90                   	nop
80103594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103598:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010359e:	85 c0                	test   %eax,%eax
801035a0:	0f 84 82 00 00 00    	je     80103628 <pipewrite+0x108>
801035a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035ac:	8b 40 24             	mov    0x24(%eax),%eax
801035af:	85 c0                	test   %eax,%eax
801035b1:	75 75                	jne    80103628 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035b3:	83 ec 0c             	sub    $0xc,%esp
801035b6:	56                   	push   %esi
801035b7:	e8 e4 09 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035bc:	59                   	pop    %ecx
801035bd:	58                   	pop    %eax
801035be:	57                   	push   %edi
801035bf:	53                   	push   %ebx
801035c0:	e8 3b 08 00 00       	call   80103e00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035cb:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	05 00 02 00 00       	add    $0x200,%eax
801035d9:	39 c2                	cmp    %eax,%edx
801035db:	74 bb                	je     80103598 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e0:	8d 4a 01             	lea    0x1(%edx),%ecx
801035e3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035e7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ed:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801035f3:	0f b6 00             	movzbl (%eax),%eax
801035f6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801035fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801035fd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80103600:	0f 85 58 ff ff ff    	jne    8010355e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103606:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	52                   	push   %edx
80103610:	e8 8b 09 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103615:	89 3c 24             	mov    %edi,(%esp)
80103618:	e8 43 0e 00 00       	call   80104460 <release>
  return n;
8010361d:	83 c4 10             	add    $0x10,%esp
80103620:	8b 45 10             	mov    0x10(%ebp),%eax
80103623:	eb 14                	jmp    80103639 <pipewrite+0x119>
80103625:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103628:	83 ec 0c             	sub    $0xc,%esp
8010362b:	57                   	push   %edi
8010362c:	e8 2f 0e 00 00       	call   80104460 <release>
        return -1;
80103631:	83 c4 10             	add    $0x10,%esp
80103634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103639:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010363c:	5b                   	pop    %ebx
8010363d:	5e                   	pop    %esi
8010363e:	5f                   	pop    %edi
8010363f:	5d                   	pop    %ebp
80103640:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103641:	89 ca                	mov    %ecx,%edx
80103643:	eb 98                	jmp    801035dd <pipewrite+0xbd>
80103645:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103650 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 18             	sub    $0x18,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010365c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010365f:	53                   	push   %ebx
80103660:	e8 1b 0c 00 00       	call   80104280 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103674:	75 6a                	jne    801036e0 <piperead+0x90>
80103676:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010367c:	85 f6                	test   %esi,%esi
8010367e:	0f 84 cc 00 00 00    	je     80103750 <piperead+0x100>
80103684:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010368a:	eb 2d                	jmp    801036b9 <piperead+0x69>
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103690:	83 ec 08             	sub    $0x8,%esp
80103693:	53                   	push   %ebx
80103694:	56                   	push   %esi
80103695:	e8 66 07 00 00       	call   80103e00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801036a3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801036a9:	75 35                	jne    801036e0 <piperead+0x90>
801036ab:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801036b1:	85 d2                	test   %edx,%edx
801036b3:	0f 84 97 00 00 00    	je     80103750 <piperead+0x100>
    if(proc->killed){
801036b9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036c0:	8b 4a 24             	mov    0x24(%edx),%ecx
801036c3:	85 c9                	test   %ecx,%ecx
801036c5:	74 c9                	je     80103690 <piperead+0x40>
      release(&p->lock);
801036c7:	83 ec 0c             	sub    $0xc,%esp
801036ca:	53                   	push   %ebx
801036cb:	e8 90 0d 00 00       	call   80104460 <release>
      return -1;
801036d0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036d3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036db:	5b                   	pop    %ebx
801036dc:	5e                   	pop    %esi
801036dd:	5f                   	pop    %edi
801036de:	5d                   	pop    %ebp
801036df:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036e0:	8b 45 10             	mov    0x10(%ebp),%eax
801036e3:	85 c0                	test   %eax,%eax
801036e5:	7e 69                	jle    80103750 <piperead+0x100>
    if(p->nread == p->nwrite)
801036e7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036ed:	31 c9                	xor    %ecx,%ecx
801036ef:	eb 15                	jmp    80103706 <piperead+0xb6>
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036fe:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103704:	74 5a                	je     80103760 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103706:	8d 72 01             	lea    0x1(%edx),%esi
80103709:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010370f:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103715:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
8010371a:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	83 c1 01             	add    $0x1,%ecx
80103720:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103723:	75 d3                	jne    801036f8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103725:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	52                   	push   %edx
8010372f:	e8 6c 08 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103734:	89 1c 24             	mov    %ebx,(%esp)
80103737:	e8 24 0d 00 00       	call   80104460 <release>
  return i;
8010373c:	8b 45 10             	mov    0x10(%ebp),%eax
8010373f:	83 c4 10             	add    $0x10,%esp
}
80103742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103745:	5b                   	pop    %ebx
80103746:	5e                   	pop    %esi
80103747:	5f                   	pop    %edi
80103748:	5d                   	pop    %ebp
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103750:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103757:	eb cc                	jmp    80103725 <piperead+0xd5>
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103760:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103763:	eb c0                	jmp    80103725 <piperead+0xd5>
80103765:	66 90                	xchg   %ax,%ax
80103767:	66 90                	xchg   %ax,%ax
80103769:	66 90                	xchg   %ax,%ax
8010376b:	66 90                	xchg   %ax,%ax
8010376d:	66 90                	xchg   %ax,%ax
8010376f:	90                   	nop

80103770 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103774:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103779:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010377c:	68 a0 2d 11 80       	push   $0x80112da0
80103781:	e8 fa 0a 00 00       	call   80104280 <acquire>
80103786:	83 c4 10             	add    $0x10,%esp
80103789:	eb 10                	jmp    8010379b <allocproc+0x2b>
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103790:	83 c3 7c             	add    $0x7c,%ebx
80103793:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103799:	74 75                	je     80103810 <allocproc+0xa0>
    if(p->state == UNUSED)
8010379b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010379e:	85 c0                	test   %eax,%eax
801037a0:	75 ee                	jne    80103790 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037a2:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
801037a7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801037aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801037b1:	68 a0 2d 11 80       	push   $0x80112da0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037b6:	8d 50 01             	lea    0x1(%eax),%edx
801037b9:	89 43 10             	mov    %eax,0x10(%ebx)
801037bc:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  release(&ptable.lock);
801037c2:	e8 99 0c 00 00       	call   80104460 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037c7:	e8 d4 ec ff ff       	call   801024a0 <kalloc>
801037cc:	83 c4 10             	add    $0x10,%esp
801037cf:	85 c0                	test   %eax,%eax
801037d1:	89 43 08             	mov    %eax,0x8(%ebx)
801037d4:	74 51                	je     80103827 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037dc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801037df:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037e4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037e7:	c7 40 14 ee 56 10 80 	movl   $0x801056ee,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ee:	6a 14                	push   $0x14
801037f0:	6a 00                	push   $0x0
801037f2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037f3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037f6:	e8 b5 0c 00 00       	call   801044b0 <memset>
  p->context->eip = (uint)forkret;
801037fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037fe:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103801:	c7 40 10 30 38 10 80 	movl   $0x80103830,0x10(%eax)

  return p;
80103808:	89 d8                	mov    %ebx,%eax
}
8010380a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010380d:	c9                   	leave  
8010380e:	c3                   	ret    
8010380f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	68 a0 2d 11 80       	push   $0x80112da0
80103818:	e8 43 0c 00 00       	call   80104460 <release>
  return 0;
8010381d:	83 c4 10             	add    $0x10,%esp
80103820:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103825:	c9                   	leave  
80103826:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103827:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010382e:	eb da                	jmp    8010380a <allocproc+0x9a>

80103830 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103836:	68 a0 2d 11 80       	push   $0x80112da0
8010383b:	e8 20 0c 00 00       	call   80104460 <release>

  if (first) {
80103840:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	85 c0                	test   %eax,%eax
8010384a:	75 04                	jne    80103850 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010384c:	c9                   	leave  
8010384d:	c3                   	ret    
8010384e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103850:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103853:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010385a:	00 00 00 
    iinit(ROOTDEV);
8010385d:	6a 01                	push   $0x1
8010385f:	e8 1c dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103864:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010386b:	e8 d0 f2 ff ff       	call   80102b40 <initlog>
80103870:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103873:	c9                   	leave  
80103874:	c3                   	ret    
80103875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103886:	68 ed 74 10 80       	push   $0x801074ed
8010388b:	68 a0 2d 11 80       	push   $0x80112da0
80103890:	e8 cb 09 00 00       	call   80104260 <initlock>
}
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	c9                   	leave  
80103899:	c3                   	ret    
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038a0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801038a7:	e8 c4 fe ff ff       	call   80103770 <allocproc>
801038ac:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801038ae:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801038b3:	e8 68 30 00 00       	call   80106920 <setupkvm>
801038b8:	85 c0                	test   %eax,%eax
801038ba:	89 43 04             	mov    %eax,0x4(%ebx)
801038bd:	0f 84 bd 00 00 00    	je     80103980 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038c3:	83 ec 04             	sub    $0x4,%esp
801038c6:	68 30 00 00 00       	push   $0x30
801038cb:	68 60 a4 10 80       	push   $0x8010a460
801038d0:	50                   	push   %eax
801038d1:	e8 ca 31 00 00       	call   80106aa0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801038d6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801038d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038df:	6a 4c                	push   $0x4c
801038e1:	6a 00                	push   $0x0
801038e3:	ff 73 18             	pushl  0x18(%ebx)
801038e6:	e8 c5 0b 00 00       	call   801044b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038eb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ee:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038f3:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038f8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103902:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010390d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103911:	8b 43 18             	mov    0x18(%ebx),%eax
80103914:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103918:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010391c:	8b 43 18             	mov    0x18(%ebx),%eax
8010391f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103926:	8b 43 18             	mov    0x18(%ebx),%eax
80103929:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103930:	8b 43 18             	mov    0x18(%ebx),%eax
80103933:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010393a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010393d:	6a 10                	push   $0x10
8010393f:	68 0d 75 10 80       	push   $0x8010750d
80103944:	50                   	push   %eax
80103945:	e8 66 0d 00 00       	call   801046b0 <safestrcpy>
  p->cwd = namei("/");
8010394a:	c7 04 24 16 75 10 80 	movl   $0x80107516,(%esp)
80103951:	e8 5a e5 ff ff       	call   80101eb0 <namei>
80103956:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103959:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103960:	e8 1b 09 00 00       	call   80104280 <acquire>

  p->state = RUNNABLE;
80103965:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010396c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103973:	e8 e8 0a 00 00       	call   80104460 <release>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397e:	c9                   	leave  
8010397f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	68 f4 74 10 80       	push   $0x801074f4
80103988:	e8 e3 c9 ff ff       	call   80100370 <panic>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
80103996:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010399d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801039a0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801039a2:	83 f9 00             	cmp    $0x0,%ecx
801039a5:	7e 39                	jle    801039e0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801039a7:	83 ec 04             	sub    $0x4,%esp
801039aa:	01 c1                	add    %eax,%ecx
801039ac:	51                   	push   %ecx
801039ad:	50                   	push   %eax
801039ae:	ff 72 04             	pushl  0x4(%edx)
801039b1:	e8 2a 32 00 00       	call   80106be0 <allocuvm>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	85 c0                	test   %eax,%eax
801039bb:	74 3b                	je     801039f8 <growproc+0x68>
801039bd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801039c4:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801039c6:	83 ec 0c             	sub    $0xc,%esp
801039c9:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
801039d0:	e8 fb 2f 00 00       	call   801069d0 <switchuvm>
  return 0;
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	31 c0                	xor    %eax,%eax
}
801039da:	c9                   	leave  
801039db:	c3                   	ret    
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039e0:	74 e2                	je     801039c4 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801039e2:	83 ec 04             	sub    $0x4,%esp
801039e5:	01 c1                	add    %eax,%ecx
801039e7:	51                   	push   %ecx
801039e8:	50                   	push   %eax
801039e9:	ff 72 04             	pushl  0x4(%edx)
801039ec:	e8 ef 32 00 00       	call   80106ce0 <deallocuvm>
801039f1:	83 c4 10             	add    $0x10,%esp
801039f4:	85 c0                	test   %eax,%eax
801039f6:	75 c5                	jne    801039bd <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
801039f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
801039fd:	c9                   	leave  
801039fe:	c3                   	ret    
801039ff:	90                   	nop

80103a00 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a09:	e8 62 fd ff ff       	call   80103770 <allocproc>
80103a0e:	85 c0                	test   %eax,%eax
80103a10:	0f 84 d6 00 00 00    	je     80103aec <fork+0xec>
80103a16:	89 c3                	mov    %eax,%ebx
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	ff 30                	pushl  (%eax)
80103a23:	ff 70 04             	pushl  0x4(%eax)
80103a26:	e8 95 33 00 00       	call   80106dc0 <copyuvm>
80103a2b:	83 c4 10             	add    $0x10,%esp
80103a2e:	85 c0                	test   %eax,%eax
80103a30:	89 43 04             	mov    %eax,0x4(%ebx)
80103a33:	0f 84 ba 00 00 00    	je     80103af3 <fork+0xf3>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a3f:	8b 7b 18             	mov    0x18(%ebx),%edi
80103a42:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a47:	8b 00                	mov    (%eax),%eax
80103a49:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a51:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103a54:	8b 70 18             	mov    0x18(%eax),%esi
80103a57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a59:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a65:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103a70:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a74:	85 c0                	test   %eax,%eax
80103a76:	74 17                	je     80103a8f <fork+0x8f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103a78:	83 ec 0c             	sub    $0xc,%esp
80103a7b:	50                   	push   %eax
80103a7c:	e8 6f d3 ff ff       	call   80100df0 <filedup>
80103a81:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103a85:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a8c:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a8f:	83 c6 01             	add    $0x1,%esi
80103a92:	83 fe 10             	cmp    $0x10,%esi
80103a95:	75 d9                	jne    80103a70 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103a97:	83 ec 0c             	sub    $0xc,%esp
80103a9a:	ff 72 68             	pushl  0x68(%edx)
80103a9d:	e8 ae db ff ff       	call   80101650 <idup>
80103aa2:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103aa5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103aab:	83 c4 0c             	add    $0xc,%esp
80103aae:	6a 10                	push   $0x10
80103ab0:	83 c0 6c             	add    $0x6c,%eax
80103ab3:	50                   	push   %eax
80103ab4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ab7:	50                   	push   %eax
80103ab8:	e8 f3 0b 00 00       	call   801046b0 <safestrcpy>

  pid = np->pid;
80103abd:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103ac0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ac7:	e8 b4 07 00 00       	call   80104280 <acquire>

  np->state = RUNNABLE;
80103acc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103ad3:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ada:	e8 81 09 00 00       	call   80104460 <release>

  return pid;
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	89 f0                	mov    %esi,%eax
}
80103ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ae7:	5b                   	pop    %ebx
80103ae8:	5e                   	pop    %esi
80103ae9:	5f                   	pop    %edi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103af1:	eb f1                	jmp    80103ae4 <fork+0xe4>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103af3:	83 ec 0c             	sub    $0xc,%esp
80103af6:	ff 73 08             	pushl  0x8(%ebx)
80103af9:	e8 f2 e7 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
80103afe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b05:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b0c:	83 c4 10             	add    $0x10,%esp
80103b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b14:	eb ce                	jmp    80103ae4 <fork+0xe4>
80103b16:	8d 76 00             	lea    0x0(%esi),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
80103b27:	89 f6                	mov    %esi,%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b30:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b34:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b39:	68 a0 2d 11 80       	push   $0x80112da0
80103b3e:	e8 3d 07 00 00       	call   80104280 <acquire>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	eb 13                	jmp    80103b5b <scheduler+0x3b>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b50:	83 c3 7c             	add    $0x7c,%ebx
80103b53:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103b59:	74 55                	je     80103bb0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103b5b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b5f:	75 ef                	jne    80103b50 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b61:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103b64:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103b6b:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b6c:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b6f:	e8 5c 2e 00 00       	call   801069d0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103b74:	58                   	pop    %eax
80103b75:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b7b:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103b82:	5a                   	pop    %edx
80103b83:	ff 73 a0             	pushl  -0x60(%ebx)
80103b86:	83 c0 04             	add    $0x4,%eax
80103b89:	50                   	push   %eax
80103b8a:	e8 7c 0b 00 00       	call   8010470b <swtch>
      switchkvm();
80103b8f:	e8 1c 2e 00 00       	call   801069b0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b94:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b97:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b9d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ba4:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba8:	75 b1                	jne    80103b5b <scheduler+0x3b>
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	68 a0 2d 11 80       	push   $0x80112da0
80103bb8:	e8 a3 08 00 00       	call   80104460 <release>

  }
80103bbd:	83 c4 10             	add    $0x10,%esp
80103bc0:	e9 6b ff ff ff       	jmp    80103b30 <scheduler+0x10>
80103bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103bd7:	68 a0 2d 11 80       	push   $0x80112da0
80103bdc:	e8 cf 07 00 00       	call   801043b0 <holding>
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 4c                	je     80103c34 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103be8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103bef:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103bf6:	75 63                	jne    80103c5b <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103bf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103c02:	74 4a                	je     80103c4e <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c04:	9c                   	pushf  
80103c05:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c06:	80 e5 02             	and    $0x2,%ch
80103c09:	75 36                	jne    80103c41 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103c0b:	83 ec 08             	sub    $0x8,%esp
80103c0e:	83 c0 1c             	add    $0x1c,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103c11:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c17:	ff 72 04             	pushl  0x4(%edx)
80103c1a:	50                   	push   %eax
80103c1b:	e8 eb 0a 00 00       	call   8010470b <swtch>
  cpu->intena = intena;
80103c20:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c26:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103c29:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c32:	c9                   	leave  
80103c33:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c34:	83 ec 0c             	sub    $0xc,%esp
80103c37:	68 18 75 10 80       	push   $0x80107518
80103c3c:	e8 2f c7 ff ff       	call   80100370 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c41:	83 ec 0c             	sub    $0xc,%esp
80103c44:	68 44 75 10 80       	push   $0x80107544
80103c49:	e8 22 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	68 36 75 10 80       	push   $0x80107536
80103c56:	e8 15 c7 ff ff       	call   80100370 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103c5b:	83 ec 0c             	sub    $0xc,%esp
80103c5e:	68 2a 75 10 80       	push   $0x8010752a
80103c63:	e8 08 c7 ff ff       	call   80100370 <panic>
80103c68:	90                   	nop
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c70:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c77:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c7d:	55                   	push   %ebp
80103c7e:	89 e5                	mov    %esp,%ebp
80103c80:	56                   	push   %esi
80103c81:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c82:	0f 84 1f 01 00 00    	je     80103da7 <exit+0x137>
80103c88:	31 db                	xor    %ebx,%ebx
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103c90:	8d 73 08             	lea    0x8(%ebx),%esi
80103c93:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c97:	85 c0                	test   %eax,%eax
80103c99:	74 1b                	je     80103cb6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103c9b:	83 ec 0c             	sub    $0xc,%esp
80103c9e:	50                   	push   %eax
80103c9f:	e8 9c d1 ff ff       	call   80100e40 <fileclose>
      proc->ofile[fd] = 0;
80103ca4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103cb5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103cb6:	83 c3 01             	add    $0x1,%ebx
80103cb9:	83 fb 10             	cmp    $0x10,%ebx
80103cbc:	75 d2                	jne    80103c90 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cbe:	e8 1d ef ff ff       	call   80102be0 <begin_op>
  iput(proc->cwd);
80103cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cc9:	83 ec 0c             	sub    $0xc,%esp
80103ccc:	ff 70 68             	pushl  0x68(%eax)
80103ccf:	e8 dc da ff ff       	call   801017b0 <iput>
  end_op();
80103cd4:	e8 77 ef ff ff       	call   80102c50 <end_op>
  proc->cwd = 0;
80103cd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cdf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103ce6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ced:	e8 8e 05 00 00       	call   80104280 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103cf2:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103cf9:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfc:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d01:	8b 51 14             	mov    0x14(%ecx),%edx
80103d04:	eb 14                	jmp    80103d1a <exit+0xaa>
80103d06:	8d 76 00             	lea    0x0(%esi),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d10:	83 c0 7c             	add    $0x7c,%eax
80103d13:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d18:	74 1c                	je     80103d36 <exit+0xc6>
    if(p->state == SLEEPING && p->chan == chan)
80103d1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d1e:	75 f0                	jne    80103d10 <exit+0xa0>
80103d20:	3b 50 20             	cmp    0x20(%eax),%edx
80103d23:	75 eb                	jne    80103d10 <exit+0xa0>
      p->state = RUNNABLE;
80103d25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d2c:	83 c0 7c             	add    $0x7c,%eax
80103d2f:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d34:	75 e4                	jne    80103d1a <exit+0xaa>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d36:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d3c:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103d41:	eb 10                	jmp    80103d53 <exit+0xe3>
80103d43:	90                   	nop
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d48:	83 c2 7c             	add    $0x7c,%edx
80103d4b:	81 fa d4 4c 11 80    	cmp    $0x80114cd4,%edx
80103d51:	74 3b                	je     80103d8e <exit+0x11e>
    if(p->parent == proc){
80103d53:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d56:	75 f0                	jne    80103d48 <exit+0xd8>
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
80103d5f:	75 e7                	jne    80103d48 <exit+0xd8>
80103d61:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103d66:	eb 12                	jmp    80103d7a <exit+0x10a>
80103d68:	90                   	nop
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d70:	83 c0 7c             	add    $0x7c,%eax
80103d73:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103d78:	74 ce                	je     80103d48 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
80103d7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d7e:	75 f0                	jne    80103d70 <exit+0x100>
80103d80:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d83:	75 eb                	jne    80103d70 <exit+0x100>
      p->state = RUNNABLE;
80103d85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d8c:	eb e2                	jmp    80103d70 <exit+0x100>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103d8e:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103d95:	e8 36 fe ff ff       	call   80103bd0 <sched>
  panic("zombie exit");
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 65 75 10 80       	push   $0x80107565
80103da2:	e8 c9 c5 ff ff       	call   80100370 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103da7:	83 ec 0c             	sub    $0xc,%esp
80103daa:	68 58 75 10 80       	push   $0x80107558
80103daf:	e8 bc c5 ff ff       	call   80100370 <panic>
80103db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103dc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103dc6:	68 a0 2d 11 80       	push   $0x80112da0
80103dcb:	e8 b0 04 00 00       	call   80104280 <acquire>
  proc->state = RUNNABLE;
80103dd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dd6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103ddd:	e8 ee fd ff ff       	call   80103bd0 <sched>
  release(&ptable.lock);
80103de2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103de9:	e8 72 06 00 00       	call   80104460 <release>
}
80103dee:	83 c4 10             	add    $0x10,%esp
80103df1:	c9                   	leave  
80103df2:	c3                   	ret    
80103df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e06:	55                   	push   %ebp
80103e07:	89 e5                	mov    %esp,%ebp
80103e09:	56                   	push   %esi
80103e0a:	53                   	push   %ebx
  if(proc == 0)
80103e0b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e0d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e13:	0f 84 97 00 00 00    	je     80103eb0 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103e19:	85 db                	test   %ebx,%ebx
80103e1b:	0f 84 82 00 00 00    	je     80103ea3 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e21:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103e27:	74 57                	je     80103e80 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e29:	83 ec 0c             	sub    $0xc,%esp
80103e2c:	68 a0 2d 11 80       	push   $0x80112da0
80103e31:	e8 4a 04 00 00       	call   80104280 <acquire>
    release(lk);
80103e36:	89 1c 24             	mov    %ebx,(%esp)
80103e39:	e8 22 06 00 00       	call   80104460 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e44:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e47:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e4e:	e8 7d fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e59:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e60:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e67:	e8 f4 05 00 00       	call   80104460 <release>
    acquire(lk);
80103e6c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e6f:	83 c4 10             	add    $0x10,%esp
  }
}
80103e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e75:	5b                   	pop    %ebx
80103e76:	5e                   	pop    %esi
80103e77:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e78:	e9 03 04 00 00       	jmp    80104280 <acquire>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103e80:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e83:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e8a:	e8 41 fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e95:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e9f:	5b                   	pop    %ebx
80103ea0:	5e                   	pop    %esi
80103ea1:	5d                   	pop    %ebp
80103ea2:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	68 77 75 10 80       	push   $0x80107577
80103eab:	e8 c0 c4 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	68 71 75 10 80       	push   $0x80107571
80103eb8:	e8 b3 c4 ff ff       	call   80100370 <panic>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi

80103ec0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103ec5:	83 ec 0c             	sub    $0xc,%esp
80103ec8:	68 a0 2d 11 80       	push   $0x80112da0
80103ecd:	e8 ae 03 00 00       	call   80104280 <acquire>
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103edb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edd:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103ee2:	eb 0f                	jmp    80103ef3 <wait+0x33>
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee8:	83 c3 7c             	add    $0x7c,%ebx
80103eeb:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103ef1:	74 1d                	je     80103f10 <wait+0x50>
      if(p->parent != proc)
80103ef3:	3b 43 14             	cmp    0x14(%ebx),%eax
80103ef6:	75 f0                	jne    80103ee8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103ef8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103efc:	74 30                	je     80103f2e <wait+0x6e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efe:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103f01:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103f0c:	75 e5                	jne    80103ef3 <wait+0x33>
80103f0e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f10:	85 d2                	test   %edx,%edx
80103f12:	74 70                	je     80103f84 <wait+0xc4>
80103f14:	8b 50 24             	mov    0x24(%eax),%edx
80103f17:	85 d2                	test   %edx,%edx
80103f19:	75 69                	jne    80103f84 <wait+0xc4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f1b:	83 ec 08             	sub    $0x8,%esp
80103f1e:	68 a0 2d 11 80       	push   $0x80112da0
80103f23:	50                   	push   %eax
80103f24:	e8 d7 fe ff ff       	call   80103e00 <sleep>
  }
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	eb a7                	jmp    80103ed5 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f2e:	83 ec 0c             	sub    $0xc,%esp
80103f31:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f34:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f37:	e8 b4 e3 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f3c:	59                   	pop    %ecx
80103f3d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f47:	e8 c4 2d 00 00       	call   80106d10 <freevm>
        p->pid = 0;
80103f4c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f53:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f5a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f5e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f6c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f73:	e8 e8 04 00 00       	call   80104460 <release>
        return pid;
80103f78:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f7e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f80:	5b                   	pop    %ebx
80103f81:	5e                   	pop    %esi
80103f82:	5d                   	pop    %ebp
80103f83:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 a0 2d 11 80       	push   $0x80112da0
80103f8c:	e8 cf 04 00 00       	call   80104460 <release>
      return -1;
80103f91:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f94:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	68 a0 2d 11 80       	push   $0x80112da0
80103faf:	e8 cc 02 00 00       	call   80104280 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb7:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103fbc:	eb 0c                	jmp    80103fca <wakeup+0x2a>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103fc8:	74 1c                	je     80103fe6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fce:	75 f0                	jne    80103fc0 <wakeup+0x20>
80103fd0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd3:	75 eb                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	83 c0 7c             	add    $0x7c,%eax
80103fdf:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103fe4:	75 e4                	jne    80103fca <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fe6:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff0:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff1:	e9 6a 04 00 00       	jmp    80104460 <release>
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010400a:	68 a0 2d 11 80       	push   $0x80112da0
8010400f:	e8 6c 02 00 00       	call   80104280 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010401c:	eb 0c                	jmp    8010402a <kill+0x2a>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	83 c0 7c             	add    $0x7c,%eax
80104023:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104028:	74 3e                	je     80104068 <kill+0x68>
    if(p->pid == pid){
8010402a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010402d:	75 f1                	jne    80104020 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010402f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104033:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403a:	74 1c                	je     80104058 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010403c:	83 ec 0c             	sub    $0xc,%esp
8010403f:	68 a0 2d 11 80       	push   $0x80112da0
80104044:	e8 17 04 00 00       	call   80104460 <release>
      return 0;
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010404e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104051:	c9                   	leave  
80104052:	c3                   	ret    
80104053:	90                   	nop
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104058:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010405f:	eb db                	jmp    8010403c <kill+0x3c>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 a0 2d 11 80       	push   $0x80112da0
80104070:	e8 eb 03 00 00       	call   80104460 <release>
  return -1;
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
80104081:	c3                   	ret    
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104099:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 24                	jmp    801040c7 <procdump+0x37>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 c6 74 10 80       	push   $0x801074c6
801040b0:	e8 ab c5 ff ff       	call   80100660 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bb:	81 fb 40 4d 11 80    	cmp    $0x80114d40,%ebx
801040c1:	0f 84 81 00 00 00    	je     80104148 <procdump+0xb8>
    if(p->state == UNUSED)
801040c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040ca:	85 c0                	test   %eax,%eax
801040cc:	74 ea                	je     801040b8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040ce:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040d1:	ba 88 75 10 80       	mov    $0x80107588,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d6:	77 11                	ja     801040e9 <procdump+0x59>
801040d8:	8b 14 85 c0 75 10 80 	mov    -0x7fef8a40(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040df:	b8 88 75 10 80       	mov    $0x80107588,%eax
801040e4:	85 d2                	test   %edx,%edx
801040e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040e9:	53                   	push   %ebx
801040ea:	52                   	push   %edx
801040eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801040ee:	68 8c 75 10 80       	push   $0x8010758c
801040f3:	e8 68 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040ff:	75 a7                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104101:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104104:	83 ec 08             	sub    $0x8,%esp
80104107:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010410a:	50                   	push   %eax
8010410b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010410e:	8b 40 0c             	mov    0xc(%eax),%eax
80104111:	83 c0 08             	add    $0x8,%eax
80104114:	50                   	push   %eax
80104115:	e8 36 02 00 00       	call   80104350 <getcallerpcs>
8010411a:	83 c4 10             	add    $0x10,%esp
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104120:	8b 17                	mov    (%edi),%edx
80104122:	85 d2                	test   %edx,%edx
80104124:	74 82                	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104126:	83 ec 08             	sub    $0x8,%esp
80104129:	83 c7 04             	add    $0x4,%edi
8010412c:	52                   	push   %edx
8010412d:	68 e9 6f 10 80       	push   $0x80106fe9
80104132:	e8 29 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	39 f7                	cmp    %esi,%edi
8010413c:	75 e2                	jne    80104120 <procdump+0x90>
8010413e:	e9 65 ff ff ff       	jmp    801040a8 <procdump+0x18>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    

80104150 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010415a:	68 d8 75 10 80       	push   $0x801075d8
8010415f:	8d 43 04             	lea    0x4(%ebx),%eax
80104162:	50                   	push   %eax
80104163:	e8 f8 00 00 00       	call   80104260 <initlock>
  lk->name = name;
80104168:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010416b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104171:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104174:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010417b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	c9                   	leave  
80104182:	c3                   	ret    
80104183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	8d 73 04             	lea    0x4(%ebx),%esi
8010419e:	56                   	push   %esi
8010419f:	e8 dc 00 00 00       	call   80104280 <acquire>
  while (lk->locked) {
801041a4:	8b 13                	mov    (%ebx),%edx
801041a6:	83 c4 10             	add    $0x10,%esp
801041a9:	85 d2                	test   %edx,%edx
801041ab:	74 16                	je     801041c3 <acquiresleep+0x33>
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041b0:	83 ec 08             	sub    $0x8,%esp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	e8 46 fc ff ff       	call   80103e00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041ba:	8b 03                	mov    (%ebx),%eax
801041bc:	83 c4 10             	add    $0x10,%esp
801041bf:	85 c0                	test   %eax,%eax
801041c1:	75 ed                	jne    801041b0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801041c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041cf:	8b 40 10             	mov    0x10(%eax),%eax
801041d2:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041d5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041db:	5b                   	pop    %ebx
801041dc:	5e                   	pop    %esi
801041dd:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801041de:	e9 7d 02 00 00       	jmp    80104460 <release>
801041e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
801041f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	8d 73 04             	lea    0x4(%ebx),%esi
801041fe:	56                   	push   %esi
801041ff:	e8 7c 00 00 00       	call   80104280 <acquire>
  lk->locked = 0;
80104204:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010420a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104211:	89 1c 24             	mov    %ebx,(%esp)
80104214:	e8 87 fd ff ff       	call   80103fa0 <wakeup>
  release(&lk->lk);
80104219:	89 75 08             	mov    %esi,0x8(%ebp)
8010421c:	83 c4 10             	add    $0x10,%esp
}
8010421f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104225:	e9 36 02 00 00       	jmp    80104460 <release>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
80104235:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010423e:	53                   	push   %ebx
8010423f:	e8 3c 00 00 00       	call   80104280 <acquire>
  r = lk->locked;
80104244:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104246:	89 1c 24             	mov    %ebx,(%esp)
80104249:	e8 12 02 00 00       	call   80104460 <release>
  return r;
}
8010424e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104251:	89 f0                	mov    %esi,%eax
80104253:	5b                   	pop    %ebx
80104254:	5e                   	pop    %esi
80104255:	5d                   	pop    %ebp
80104256:	c3                   	ret    
80104257:	66 90                	xchg   %ax,%ax
80104259:	66 90                	xchg   %ax,%ax
8010425b:	66 90                	xchg   %ax,%ax
8010425d:	66 90                	xchg   %ax,%ax
8010425f:	90                   	nop

80104260 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104266:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010426f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104272:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104279:	5d                   	pop    %ebp
8010427a:	c3                   	ret    
8010427b:	90                   	nop
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 04             	sub    $0x4,%esp
80104287:	9c                   	pushf  
80104288:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104289:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010428a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104291:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104297:	85 c0                	test   %eax,%eax
80104299:	75 0c                	jne    801042a7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
8010429b:	81 e2 00 02 00 00    	and    $0x200,%edx
801042a1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042a7:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
801042aa:	83 c0 01             	add    $0x1,%eax
801042ad:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801042b3:	8b 02                	mov    (%edx),%eax
801042b5:	85 c0                	test   %eax,%eax
801042b7:	74 05                	je     801042be <acquire+0x3e>
801042b9:	39 4a 08             	cmp    %ecx,0x8(%edx)
801042bc:	74 7a                	je     80104338 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801042be:	b9 01 00 00 00       	mov    $0x1,%ecx
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	89 c8                	mov    %ecx,%eax
801042ca:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042cd:	85 c0                	test   %eax,%eax
801042cf:	75 f7                	jne    801042c8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801042d1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801042d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801042df:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042e1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
801042e4:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042e7:	31 c0                	xor    %eax,%eax
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042fc:	77 1a                	ja     80104318 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104301:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104304:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104307:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104309:	83 f8 0a             	cmp    $0xa,%eax
8010430c:	75 e2                	jne    801042f0 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
8010430e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104311:	c9                   	leave  
80104312:	c3                   	ret    
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104318:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010431f:	83 c0 01             	add    $0x1,%eax
80104322:	83 f8 0a             	cmp    $0xa,%eax
80104325:	74 e7                	je     8010430e <acquire+0x8e>
    pcs[i] = 0;
80104327:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010432e:	83 c0 01             	add    $0x1,%eax
80104331:	83 f8 0a             	cmp    $0xa,%eax
80104334:	75 e2                	jne    80104318 <acquire+0x98>
80104336:	eb d6                	jmp    8010430e <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 e3 75 10 80       	push   $0x801075e3
80104340:	e8 2b c0 ff ff       	call   80100370 <panic>
80104345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104354:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010435a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010435d:	31 c0                	xor    %eax,%eax
8010435f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104360:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104366:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010436c:	77 1a                	ja     80104388 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010436e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104371:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104374:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104377:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104379:	83 f8 0a             	cmp    $0xa,%eax
8010437c:	75 e2                	jne    80104360 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010437e:	5b                   	pop    %ebx
8010437f:	5d                   	pop    %ebp
80104380:	c3                   	ret    
80104381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104388:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010438f:	83 c0 01             	add    $0x1,%eax
80104392:	83 f8 0a             	cmp    $0xa,%eax
80104395:	74 e7                	je     8010437e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104397:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010439e:	83 c0 01             	add    $0x1,%eax
801043a1:	83 f8 0a             	cmp    $0xa,%eax
801043a4:	75 e2                	jne    80104388 <getcallerpcs+0x38>
801043a6:	eb d6                	jmp    8010437e <getcallerpcs+0x2e>
801043a8:	90                   	nop
801043a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043b0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801043b6:	8b 02                	mov    (%edx),%eax
801043b8:	85 c0                	test   %eax,%eax
801043ba:	74 14                	je     801043d0 <holding+0x20>
801043bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801043c2:	39 42 08             	cmp    %eax,0x8(%edx)
}
801043c5:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801043c6:	0f 94 c0             	sete   %al
801043c9:	0f b6 c0             	movzbl %al,%eax
}
801043cc:	c3                   	ret    
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
801043d0:	31 c0                	xor    %eax,%eax
801043d2:	5d                   	pop    %ebp
801043d3:	c3                   	ret    
801043d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801043e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e3:	9c                   	pushf  
801043e4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801043e5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801043e6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801043ed:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801043f3:	85 c0                	test   %eax,%eax
801043f5:	75 0c                	jne    80104403 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
801043f7:	81 e1 00 02 00 00    	and    $0x200,%ecx
801043fd:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104403:	83 c0 01             	add    $0x1,%eax
80104406:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    
8010440e:	66 90                	xchg   %ax,%ax

80104410 <popcli>:

void
popcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104416:	9c                   	pushf  
80104417:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104418:	f6 c4 02             	test   $0x2,%ah
8010441b:	75 2c                	jne    80104449 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010441d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104424:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010442b:	78 0f                	js     8010443c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010442d:	75 0b                	jne    8010443a <popcli+0x2a>
8010442f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104435:	85 c0                	test   %eax,%eax
80104437:	74 01                	je     8010443a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104439:	fb                   	sti    
    sti();
}
8010443a:	c9                   	leave  
8010443b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010443c:	83 ec 0c             	sub    $0xc,%esp
8010443f:	68 02 76 10 80       	push   $0x80107602
80104444:	e8 27 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104449:	83 ec 0c             	sub    $0xc,%esp
8010444c:	68 eb 75 10 80       	push   $0x801075eb
80104451:	e8 1a bf ff ff       	call   80100370 <panic>
80104456:	8d 76 00             	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	83 ec 08             	sub    $0x8,%esp
80104466:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104469:	8b 10                	mov    (%eax),%edx
8010446b:	85 d2                	test   %edx,%edx
8010446d:	74 0c                	je     8010447b <release+0x1b>
8010446f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104476:	39 50 08             	cmp    %edx,0x8(%eax)
80104479:	74 15                	je     80104490 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	68 09 76 10 80       	push   $0x80107609
80104483:	e8 e8 be ff ff       	call   80100370 <panic>
80104488:	90                   	nop
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
80104490:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104497:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010449e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801044a9:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044aa:	e9 61 ff ff ff       	jmp    80104410 <popcli>
801044af:	90                   	nop

801044b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	53                   	push   %ebx
801044b5:	8b 55 08             	mov    0x8(%ebp),%edx
801044b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044bb:	f6 c2 03             	test   $0x3,%dl
801044be:	75 05                	jne    801044c5 <memset+0x15>
801044c0:	f6 c1 03             	test   $0x3,%cl
801044c3:	74 13                	je     801044d8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044c5:	89 d7                	mov    %edx,%edi
801044c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ca:	fc                   	cld    
801044cb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044cd:	5b                   	pop    %ebx
801044ce:	89 d0                	mov    %edx,%eax
801044d0:	5f                   	pop    %edi
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044d8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044dc:	c1 e9 02             	shr    $0x2,%ecx
801044df:	89 fb                	mov    %edi,%ebx
801044e1:	89 f8                	mov    %edi,%eax
801044e3:	c1 e3 18             	shl    $0x18,%ebx
801044e6:	c1 e0 10             	shl    $0x10,%eax
801044e9:	09 d8                	or     %ebx,%eax
801044eb:	09 f8                	or     %edi,%eax
801044ed:	c1 e7 08             	shl    $0x8,%edi
801044f0:	09 f8                	or     %edi,%eax
801044f2:	89 d7                	mov    %edx,%edi
801044f4:	fc                   	cld    
801044f5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044f7:	5b                   	pop    %ebx
801044f8:	89 d0                	mov    %edx,%eax
801044fa:	5f                   	pop    %edi
801044fb:	5d                   	pop    %ebp
801044fc:	c3                   	ret    
801044fd:	8d 76 00             	lea    0x0(%esi),%esi

80104500 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	8b 45 10             	mov    0x10(%ebp),%eax
80104508:	53                   	push   %ebx
80104509:	8b 75 0c             	mov    0xc(%ebp),%esi
8010450c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010450f:	85 c0                	test   %eax,%eax
80104511:	74 29                	je     8010453c <memcmp+0x3c>
    if(*s1 != *s2)
80104513:	0f b6 13             	movzbl (%ebx),%edx
80104516:	0f b6 0e             	movzbl (%esi),%ecx
80104519:	38 d1                	cmp    %dl,%cl
8010451b:	75 2b                	jne    80104548 <memcmp+0x48>
8010451d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104520:	31 c0                	xor    %eax,%eax
80104522:	eb 14                	jmp    80104538 <memcmp+0x38>
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104528:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010452d:	83 c0 01             	add    $0x1,%eax
80104530:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104534:	38 ca                	cmp    %cl,%dl
80104536:	75 10                	jne    80104548 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104538:	39 f8                	cmp    %edi,%eax
8010453a:	75 ec                	jne    80104528 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010453c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010453d:	31 c0                	xor    %eax,%eax
}
8010453f:	5e                   	pop    %esi
80104540:	5f                   	pop    %edi
80104541:	5d                   	pop    %ebp
80104542:	c3                   	ret    
80104543:	90                   	nop
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104548:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010454b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010454c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010454e:	5e                   	pop    %esi
8010454f:	5f                   	pop    %edi
80104550:	5d                   	pop    %ebp
80104551:	c3                   	ret    
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 45 08             	mov    0x8(%ebp),%eax
80104568:	8b 75 0c             	mov    0xc(%ebp),%esi
8010456b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010456e:	39 c6                	cmp    %eax,%esi
80104570:	73 2e                	jae    801045a0 <memmove+0x40>
80104572:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104575:	39 c8                	cmp    %ecx,%eax
80104577:	73 27                	jae    801045a0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104579:	85 db                	test   %ebx,%ebx
8010457b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010457e:	74 17                	je     80104597 <memmove+0x37>
      *--d = *--s;
80104580:	29 d9                	sub    %ebx,%ecx
80104582:	89 cb                	mov    %ecx,%ebx
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010458c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010458f:	83 ea 01             	sub    $0x1,%edx
80104592:	83 fa ff             	cmp    $0xffffffff,%edx
80104595:	75 f1                	jne    80104588 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104597:	5b                   	pop    %ebx
80104598:	5e                   	pop    %esi
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045a0:	31 d2                	xor    %edx,%edx
801045a2:	85 db                	test   %ebx,%ebx
801045a4:	74 f1                	je     80104597 <memmove+0x37>
801045a6:	8d 76 00             	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045b7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045ba:	39 d3                	cmp    %edx,%ebx
801045bc:	75 f2                	jne    801045b0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045be:	5b                   	pop    %ebx
801045bf:	5e                   	pop    %esi
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045d3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045d4:	eb 8a                	jmp    80104560 <memmove>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045e8:	53                   	push   %ebx
801045e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045ef:	85 c9                	test   %ecx,%ecx
801045f1:	74 37                	je     8010462a <strncmp+0x4a>
801045f3:	0f b6 17             	movzbl (%edi),%edx
801045f6:	0f b6 1e             	movzbl (%esi),%ebx
801045f9:	84 d2                	test   %dl,%dl
801045fb:	74 3f                	je     8010463c <strncmp+0x5c>
801045fd:	38 d3                	cmp    %dl,%bl
801045ff:	75 3b                	jne    8010463c <strncmp+0x5c>
80104601:	8d 47 01             	lea    0x1(%edi),%eax
80104604:	01 cf                	add    %ecx,%edi
80104606:	eb 1b                	jmp    80104623 <strncmp+0x43>
80104608:	90                   	nop
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104610:	0f b6 10             	movzbl (%eax),%edx
80104613:	84 d2                	test   %dl,%dl
80104615:	74 21                	je     80104638 <strncmp+0x58>
80104617:	0f b6 19             	movzbl (%ecx),%ebx
8010461a:	83 c0 01             	add    $0x1,%eax
8010461d:	89 ce                	mov    %ecx,%esi
8010461f:	38 da                	cmp    %bl,%dl
80104621:	75 19                	jne    8010463c <strncmp+0x5c>
80104623:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104625:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104628:	75 e6                	jne    80104610 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010462a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010462b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010462d:	5e                   	pop    %esi
8010462e:	5f                   	pop    %edi
8010462f:	5d                   	pop    %ebp
80104630:	c3                   	ret    
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104638:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010463c:	0f b6 c2             	movzbl %dl,%eax
8010463f:	29 d8                	sub    %ebx,%eax
}
80104641:	5b                   	pop    %ebx
80104642:	5e                   	pop    %esi
80104643:	5f                   	pop    %edi
80104644:	5d                   	pop    %ebp
80104645:	c3                   	ret    
80104646:	8d 76 00             	lea    0x0(%esi),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 45 08             	mov    0x8(%ebp),%eax
80104658:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010465b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010465e:	89 c2                	mov    %eax,%edx
80104660:	eb 19                	jmp    8010467b <strncpy+0x2b>
80104662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104668:	83 c3 01             	add    $0x1,%ebx
8010466b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010466f:	83 c2 01             	add    $0x1,%edx
80104672:	84 c9                	test   %cl,%cl
80104674:	88 4a ff             	mov    %cl,-0x1(%edx)
80104677:	74 09                	je     80104682 <strncpy+0x32>
80104679:	89 f1                	mov    %esi,%ecx
8010467b:	85 c9                	test   %ecx,%ecx
8010467d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104680:	7f e6                	jg     80104668 <strncpy+0x18>
    ;
  while(n-- > 0)
80104682:	31 c9                	xor    %ecx,%ecx
80104684:	85 f6                	test   %esi,%esi
80104686:	7e 17                	jle    8010469f <strncpy+0x4f>
80104688:	90                   	nop
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104690:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104694:	89 f3                	mov    %esi,%ebx
80104696:	83 c1 01             	add    $0x1,%ecx
80104699:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010469b:	85 db                	test   %ebx,%ebx
8010469d:	7f f1                	jg     80104690 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010469f:	5b                   	pop    %ebx
801046a0:	5e                   	pop    %esi
801046a1:	5d                   	pop    %ebp
801046a2:	c3                   	ret    
801046a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046b8:	8b 45 08             	mov    0x8(%ebp),%eax
801046bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046be:	85 c9                	test   %ecx,%ecx
801046c0:	7e 26                	jle    801046e8 <safestrcpy+0x38>
801046c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046c6:	89 c1                	mov    %eax,%ecx
801046c8:	eb 17                	jmp    801046e1 <safestrcpy+0x31>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046d0:	83 c2 01             	add    $0x1,%edx
801046d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046d7:	83 c1 01             	add    $0x1,%ecx
801046da:	84 db                	test   %bl,%bl
801046dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046df:	74 04                	je     801046e5 <safestrcpy+0x35>
801046e1:	39 f2                	cmp    %esi,%edx
801046e3:	75 eb                	jne    801046d0 <safestrcpy+0x20>
    ;
  *s = 0;
801046e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046e8:	5b                   	pop    %ebx
801046e9:	5e                   	pop    %esi
801046ea:	5d                   	pop    %ebp
801046eb:	c3                   	ret    
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <strlen>:

int
strlen(const char *s)
{
801046f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046f1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046f8:	80 3a 00             	cmpb   $0x0,(%edx)
801046fb:	74 0c                	je     80104709 <strlen+0x19>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104707:	75 f7                	jne    80104700 <strlen+0x10>
    ;
  return n;
}
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    

8010470b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010470b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010470f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104713:	55                   	push   %ebp
  pushl %ebx
80104714:	53                   	push   %ebx
  pushl %esi
80104715:	56                   	push   %esi
  pushl %edi
80104716:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104717:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104719:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010471b:	5f                   	pop    %edi
  popl %esi
8010471c:	5e                   	pop    %esi
  popl %ebx
8010471d:	5b                   	pop    %ebx
  popl %ebp
8010471e:	5d                   	pop    %ebp
  ret
8010471f:	c3                   	ret    

80104720 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104720:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104721:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104728:	89 e5                	mov    %esp,%ebp
8010472a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010472d:	8b 12                	mov    (%edx),%edx
8010472f:	39 c2                	cmp    %eax,%edx
80104731:	76 15                	jbe    80104748 <fetchint+0x28>
80104733:	8d 48 04             	lea    0x4(%eax),%ecx
80104736:	39 ca                	cmp    %ecx,%edx
80104738:	72 0e                	jb     80104748 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010473a:	8b 10                	mov    (%eax),%edx
8010473c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473f:	89 10                	mov    %edx,(%eax)
  return 0;
80104741:	31 c0                	xor    %eax,%eax
}
80104743:	5d                   	pop    %ebp
80104744:	c3                   	ret    
80104745:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010474d:	5d                   	pop    %ebp
8010474e:	c3                   	ret    
8010474f:	90                   	nop

80104750 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104750:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104751:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104757:	89 e5                	mov    %esp,%ebp
80104759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010475c:	39 08                	cmp    %ecx,(%eax)
8010475e:	76 2c                	jbe    8010478c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104760:	8b 55 0c             	mov    0xc(%ebp),%edx
80104763:	89 c8                	mov    %ecx,%eax
80104765:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104767:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010476e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104770:	39 d1                	cmp    %edx,%ecx
80104772:	73 18                	jae    8010478c <fetchstr+0x3c>
    if(*s == 0)
80104774:	80 39 00             	cmpb   $0x0,(%ecx)
80104777:	75 0c                	jne    80104785 <fetchstr+0x35>
80104779:	eb 1d                	jmp    80104798 <fetchstr+0x48>
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104780:	80 38 00             	cmpb   $0x0,(%eax)
80104783:	74 13                	je     80104798 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104785:	83 c0 01             	add    $0x1,%eax
80104788:	39 c2                	cmp    %eax,%edx
8010478a:	77 f4                	ja     80104780 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010478c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	90                   	nop
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104798:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010479a:	5d                   	pop    %ebp
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047a7:	55                   	push   %ebp
801047a8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047aa:	8b 42 18             	mov    0x18(%edx),%eax
801047ad:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047b0:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047b2:	8b 40 44             	mov    0x44(%eax),%eax
801047b5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801047b8:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047bb:	39 d1                	cmp    %edx,%ecx
801047bd:	73 19                	jae    801047d8 <argint+0x38>
801047bf:	8d 48 08             	lea    0x8(%eax),%ecx
801047c2:	39 ca                	cmp    %ecx,%edx
801047c4:	72 12                	jb     801047d8 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
801047c6:	8b 50 04             	mov    0x4(%eax),%edx
801047c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801047cc:	89 10                	mov    %edx,(%eax)
  return 0;
801047ce:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801047d0:	5d                   	pop    %ebp
801047d1:	c3                   	ret    
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801047d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801047dd:	5d                   	pop    %ebp
801047de:	c3                   	ret    
801047df:	90                   	nop

801047e0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047e6:	55                   	push   %ebp
801047e7:	89 e5                	mov    %esp,%ebp
801047e9:	56                   	push   %esi
801047ea:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047eb:	8b 48 18             	mov    0x18(%eax),%ecx
801047ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047f1:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047f4:	8b 49 44             	mov    0x44(%ecx),%ecx
801047f7:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047fa:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
801047fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104801:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104804:	39 ce                	cmp    %ecx,%esi
80104806:	73 1f                	jae    80104827 <argptr+0x47>
80104808:	8d 73 08             	lea    0x8(%ebx),%esi
8010480b:	39 f1                	cmp    %esi,%ecx
8010480d:	72 18                	jb     80104827 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010480f:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104811:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104814:	78 11                	js     80104827 <argptr+0x47>
80104816:	39 cb                	cmp    %ecx,%ebx
80104818:	73 0d                	jae    80104827 <argptr+0x47>
8010481a:	01 da                	add    %ebx,%edx
8010481c:	39 ca                	cmp    %ecx,%edx
8010481e:	77 07                	ja     80104827 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104820:	8b 45 0c             	mov    0xc(%ebp),%eax
80104823:	89 18                	mov    %ebx,(%eax)
  return 0;
80104825:	31 c0                	xor    %eax,%eax
}
80104827:	5b                   	pop    %ebx
80104828:	5e                   	pop    %esi
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret    
8010482b:	90                   	nop
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104830:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104836:	55                   	push   %ebp
80104837:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104839:	8b 50 18             	mov    0x18(%eax),%edx
8010483c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010483f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104841:	8b 52 44             	mov    0x44(%edx),%edx
80104844:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104847:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010484a:	39 c1                	cmp    %eax,%ecx
8010484c:	73 07                	jae    80104855 <argstr+0x25>
8010484e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104851:	39 c8                	cmp    %ecx,%eax
80104853:	73 0b                	jae    80104860 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104860:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104863:	39 c1                	cmp    %eax,%ecx
80104865:	73 ee                	jae    80104855 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104867:	8b 55 0c             	mov    0xc(%ebp),%edx
8010486a:	89 c8                	mov    %ecx,%eax
8010486c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010486e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104875:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104877:	39 d1                	cmp    %edx,%ecx
80104879:	73 da                	jae    80104855 <argstr+0x25>
    if(*s == 0)
8010487b:	80 39 00             	cmpb   $0x0,(%ecx)
8010487e:	75 0d                	jne    8010488d <argstr+0x5d>
80104880:	eb 1e                	jmp    801048a0 <argstr+0x70>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104888:	80 38 00             	cmpb   $0x0,(%eax)
8010488b:	74 13                	je     801048a0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010488d:	83 c0 01             	add    $0x1,%eax
80104890:	39 c2                	cmp    %eax,%edx
80104892:	77 f4                	ja     80104888 <argstr+0x58>
80104894:	eb bf                	jmp    80104855 <argstr+0x25>
80104896:	8d 76 00             	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
801048a0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801048a2:	5d                   	pop    %ebp
801048a3:	c3                   	ret    
801048a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048b0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
801048b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048be:	8b 5a 18             	mov    0x18(%edx),%ebx
801048c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048c4:	8d 48 ff             	lea    -0x1(%eax),%ecx
801048c7:	83 f9 14             	cmp    $0x14,%ecx
801048ca:	77 1c                	ja     801048e8 <syscall+0x38>
801048cc:	8b 0c 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%ecx
801048d3:	85 c9                	test   %ecx,%ecx
801048d5:	74 11                	je     801048e8 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
801048d7:	ff d1                	call   *%ecx
801048d9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
801048dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048df:	c9                   	leave  
801048e0:	c3                   	ret    
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048e8:	50                   	push   %eax
            proc->pid, proc->name, num);
801048e9:	8d 42 6c             	lea    0x6c(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048ec:	50                   	push   %eax
801048ed:	ff 72 10             	pushl  0x10(%edx)
801048f0:	68 11 76 10 80       	push   $0x80107611
801048f5:	e8 66 bd ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801048fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104900:	83 c4 10             	add    $0x10,%esp
80104903:	8b 40 18             	mov    0x18(%eax),%eax
80104906:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010490d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104910:	c9                   	leave  
80104911:	c3                   	ret    
80104912:	66 90                	xchg   %ax,%ax
80104914:	66 90                	xchg   %ax,%ax
80104916:	66 90                	xchg   %ax,%ax
80104918:	66 90                	xchg   %ax,%ax
8010491a:	66 90                	xchg   %ax,%ax
8010491c:	66 90                	xchg   %ax,%ax
8010491e:	66 90                	xchg   %ax,%ax

80104920 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104926:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104929:	83 ec 44             	sub    $0x44,%esp
8010492c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010492f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104932:	56                   	push   %esi
80104933:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104934:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104937:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010493a:	e8 91 d5 ff ff       	call   80101ed0 <nameiparent>
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	85 c0                	test   %eax,%eax
80104944:	0f 84 f6 00 00 00    	je     80104a40 <create+0x120>
    return 0;
  ilock(dp);
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	89 c7                	mov    %eax,%edi
8010494f:	50                   	push   %eax
80104950:	e8 2b cd ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104955:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104958:	83 c4 0c             	add    $0xc,%esp
8010495b:	50                   	push   %eax
8010495c:	56                   	push   %esi
8010495d:	57                   	push   %edi
8010495e:	e8 2d d2 ff ff       	call   80101b90 <dirlookup>
80104963:	83 c4 10             	add    $0x10,%esp
80104966:	85 c0                	test   %eax,%eax
80104968:	89 c3                	mov    %eax,%ebx
8010496a:	74 54                	je     801049c0 <create+0xa0>
    iunlockput(dp);
8010496c:	83 ec 0c             	sub    $0xc,%esp
8010496f:	57                   	push   %edi
80104970:	e8 7b cf ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104975:	89 1c 24             	mov    %ebx,(%esp)
80104978:	e8 03 cd ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104985:	75 19                	jne    801049a0 <create+0x80>
80104987:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010498c:	89 d8                	mov    %ebx,%eax
8010498e:	75 10                	jne    801049a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	5b                   	pop    %ebx
80104994:	5e                   	pop    %esi
80104995:	5f                   	pop    %edi
80104996:	5d                   	pop    %ebp
80104997:	c3                   	ret    
80104998:	90                   	nop
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	53                   	push   %ebx
801049a4:	e8 47 cf ff ff       	call   801018f0 <iunlockput>
    return 0;
801049a9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049af:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049b1:	5b                   	pop    %ebx
801049b2:	5e                   	pop    %esi
801049b3:	5f                   	pop    %edi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049c4:	83 ec 08             	sub    $0x8,%esp
801049c7:	50                   	push   %eax
801049c8:	ff 37                	pushl  (%edi)
801049ca:	e8 41 cb ff ff       	call   80101510 <ialloc>
801049cf:	83 c4 10             	add    $0x10,%esp
801049d2:	85 c0                	test   %eax,%eax
801049d4:	89 c3                	mov    %eax,%ebx
801049d6:	0f 84 cc 00 00 00    	je     80104aa8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801049dc:	83 ec 0c             	sub    $0xc,%esp
801049df:	50                   	push   %eax
801049e0:	e8 9b cc ff ff       	call   80101680 <ilock>
  ip->major = major;
801049e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049e9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801049ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049f1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801049f5:	b8 01 00 00 00       	mov    $0x1,%eax
801049fa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049fe:	89 1c 24             	mov    %ebx,(%esp)
80104a01:	e8 ca cb ff ff       	call   801015d0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a06:	83 c4 10             	add    $0x10,%esp
80104a09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a0e:	74 40                	je     80104a50 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a10:	83 ec 04             	sub    $0x4,%esp
80104a13:	ff 73 04             	pushl  0x4(%ebx)
80104a16:	56                   	push   %esi
80104a17:	57                   	push   %edi
80104a18:	e8 d3 d3 ff ff       	call   80101df0 <dirlink>
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	85 c0                	test   %eax,%eax
80104a22:	78 77                	js     80104a9b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	57                   	push   %edi
80104a28:	e8 c3 ce ff ff       	call   801018f0 <iunlockput>

  return ip;
80104a2d:	83 c4 10             	add    $0x10,%esp
}
80104a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a33:	89 d8                	mov    %ebx,%eax
}
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5f                   	pop    %edi
80104a38:	5d                   	pop    %ebp
80104a39:	c3                   	ret    
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a40:	31 c0                	xor    %eax,%eax
80104a42:	e9 49 ff ff ff       	jmp    80104990 <create+0x70>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a55:	83 ec 0c             	sub    $0xc,%esp
80104a58:	57                   	push   %edi
80104a59:	e8 72 cb ff ff       	call   801015d0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a5e:	83 c4 0c             	add    $0xc,%esp
80104a61:	ff 73 04             	pushl  0x4(%ebx)
80104a64:	68 b4 76 10 80       	push   $0x801076b4
80104a69:	53                   	push   %ebx
80104a6a:	e8 81 d3 ff ff       	call   80101df0 <dirlink>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	78 18                	js     80104a8e <create+0x16e>
80104a76:	83 ec 04             	sub    $0x4,%esp
80104a79:	ff 77 04             	pushl  0x4(%edi)
80104a7c:	68 b3 76 10 80       	push   $0x801076b3
80104a81:	53                   	push   %ebx
80104a82:	e8 69 d3 ff ff       	call   80101df0 <dirlink>
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	85 c0                	test   %eax,%eax
80104a8c:	79 82                	jns    80104a10 <create+0xf0>
      panic("create dots");
80104a8e:	83 ec 0c             	sub    $0xc,%esp
80104a91:	68 a7 76 10 80       	push   $0x801076a7
80104a96:	e8 d5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 b6 76 10 80       	push   $0x801076b6
80104aa3:	e8 c8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 98 76 10 80       	push   $0x80107698
80104ab0:	e8 bb b8 ff ff       	call   80100370 <panic>
80104ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aca:	89 d3                	mov    %edx,%ebx
80104acc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104acf:	50                   	push   %eax
80104ad0:	6a 00                	push   $0x0
80104ad2:	e8 c9 fc ff ff       	call   801047a0 <argint>
80104ad7:	83 c4 10             	add    $0x10,%esp
80104ada:	85 c0                	test   %eax,%eax
80104adc:	78 3a                	js     80104b18 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae1:	83 f8 0f             	cmp    $0xf,%eax
80104ae4:	77 32                	ja     80104b18 <argfd.constprop.0+0x58>
80104ae6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104aed:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104af1:	85 d2                	test   %edx,%edx
80104af3:	74 23                	je     80104b18 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104af5:	85 f6                	test   %esi,%esi
80104af7:	74 02                	je     80104afb <argfd.constprop.0+0x3b>
    *pfd = fd;
80104af9:	89 06                	mov    %eax,(%esi)
  if(pf)
80104afb:	85 db                	test   %ebx,%ebx
80104afd:	74 11                	je     80104b10 <argfd.constprop.0+0x50>
    *pf = f;
80104aff:	89 13                	mov    %edx,(%ebx)
  return 0;
80104b01:	31 c0                	xor    %eax,%eax
}
80104b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b06:	5b                   	pop    %ebx
80104b07:	5e                   	pop    %esi
80104b08:	5d                   	pop    %ebp
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b10:	31 c0                	xor    %eax,%eax
80104b12:	eb ef                	jmp    80104b03 <argfd.constprop.0+0x43>
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1d:	eb e4                	jmp    80104b03 <argfd.constprop.0+0x43>
80104b1f:	90                   	nop

80104b20 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b20:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b21:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b26:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b29:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b2c:	e8 8f ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b31:	85 c0                	test   %eax,%eax
80104b33:	78 1b                	js     80104b50 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b3e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104b40:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104b44:	85 c9                	test   %ecx,%ecx
80104b46:	74 18                	je     80104b60 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b48:	83 c3 01             	add    $0x1,%ebx
80104b4b:	83 fb 10             	cmp    $0x10,%ebx
80104b4e:	75 f0                	jne    80104b40 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b58:	c9                   	leave  
80104b59:	c3                   	ret    
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b60:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104b63:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b67:	52                   	push   %edx
80104b68:	e8 83 c2 ff ff       	call   80100df0 <filedup>
  return fd;
80104b6d:	89 d8                	mov    %ebx,%eax
80104b6f:	83 c4 10             	add    $0x10,%esp
}
80104b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b75:	c9                   	leave  
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <sys_read>:

int
sys_read(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b8b:	e8 30 ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 4c                	js     80104be0 <sys_read+0x60>
80104b94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b97:	83 ec 08             	sub    $0x8,%esp
80104b9a:	50                   	push   %eax
80104b9b:	6a 02                	push   $0x2
80104b9d:	e8 fe fb ff ff       	call   801047a0 <argint>
80104ba2:	83 c4 10             	add    $0x10,%esp
80104ba5:	85 c0                	test   %eax,%eax
80104ba7:	78 37                	js     80104be0 <sys_read+0x60>
80104ba9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bac:	83 ec 04             	sub    $0x4,%esp
80104baf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bb2:	50                   	push   %eax
80104bb3:	6a 01                	push   $0x1
80104bb5:	e8 26 fc ff ff       	call   801047e0 <argptr>
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	85 c0                	test   %eax,%eax
80104bbf:	78 1f                	js     80104be0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104bc1:	83 ec 04             	sub    $0x4,%esp
80104bc4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bca:	ff 75 ec             	pushl  -0x14(%ebp)
80104bcd:	e8 8e c3 ff ff       	call   80100f60 <fileread>
80104bd2:	83 c4 10             	add    $0x10,%esp
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <sys_write>:

int
sys_write(void)
{
80104bf0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bf1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104bf3:	89 e5                	mov    %esp,%ebp
80104bf5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bfb:	e8 c0 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 4c                	js     80104c50 <sys_write+0x60>
80104c04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c07:	83 ec 08             	sub    $0x8,%esp
80104c0a:	50                   	push   %eax
80104c0b:	6a 02                	push   $0x2
80104c0d:	e8 8e fb ff ff       	call   801047a0 <argint>
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	85 c0                	test   %eax,%eax
80104c17:	78 37                	js     80104c50 <sys_write+0x60>
80104c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1c:	83 ec 04             	sub    $0x4,%esp
80104c1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c22:	50                   	push   %eax
80104c23:	6a 01                	push   $0x1
80104c25:	e8 b6 fb ff ff       	call   801047e0 <argptr>
80104c2a:	83 c4 10             	add    $0x10,%esp
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	78 1f                	js     80104c50 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c31:	83 ec 04             	sub    $0x4,%esp
80104c34:	ff 75 f0             	pushl  -0x10(%ebp)
80104c37:	ff 75 f4             	pushl  -0xc(%ebp)
80104c3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c3d:	e8 ae c3 ff ff       	call   80100ff0 <filewrite>
80104c42:	83 c4 10             	add    $0x10,%esp
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <sys_close>:

int
sys_close(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c66:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c6c:	e8 4f fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c71:	85 c0                	test   %eax,%eax
80104c73:	78 2b                	js     80104ca0 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104c75:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104c7e:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104c81:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c88:	00 
  fileclose(f);
80104c89:	ff 75 f4             	pushl  -0xc(%ebp)
80104c8c:	e8 af c1 ff ff       	call   80100e40 <fileclose>
  return 0;
80104c91:	83 c4 10             	add    $0x10,%esp
80104c94:	31 c0                	xor    %eax,%eax
}
80104c96:	c9                   	leave  
80104c97:	c3                   	ret    
80104c98:	90                   	nop
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <sys_fstat>:

int
sys_fstat(void)
{
80104cb0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cb8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cbb:	e8 00 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 2c                	js     80104cf0 <sys_fstat+0x40>
80104cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cc7:	83 ec 04             	sub    $0x4,%esp
80104cca:	6a 14                	push   $0x14
80104ccc:	50                   	push   %eax
80104ccd:	6a 01                	push   $0x1
80104ccf:	e8 0c fb ff ff       	call   801047e0 <argptr>
80104cd4:	83 c4 10             	add    $0x10,%esp
80104cd7:	85 c0                	test   %eax,%eax
80104cd9:	78 15                	js     80104cf0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104cdb:	83 ec 08             	sub    $0x8,%esp
80104cde:	ff 75 f4             	pushl  -0xc(%ebp)
80104ce1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce4:	e8 27 c2 ff ff       	call   80100f10 <filestat>
80104ce9:	83 c4 10             	add    $0x10,%esp
}
80104cec:	c9                   	leave  
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d06:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d09:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d0c:	50                   	push   %eax
80104d0d:	6a 00                	push   $0x0
80104d0f:	e8 1c fb ff ff       	call   80104830 <argstr>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	0f 88 fb 00 00 00    	js     80104e1a <sys_link+0x11a>
80104d1f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d22:	83 ec 08             	sub    $0x8,%esp
80104d25:	50                   	push   %eax
80104d26:	6a 01                	push   $0x1
80104d28:	e8 03 fb ff ff       	call   80104830 <argstr>
80104d2d:	83 c4 10             	add    $0x10,%esp
80104d30:	85 c0                	test   %eax,%eax
80104d32:	0f 88 e2 00 00 00    	js     80104e1a <sys_link+0x11a>
    return -1;

  begin_op();
80104d38:	e8 a3 de ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
80104d3d:	83 ec 0c             	sub    $0xc,%esp
80104d40:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d43:	e8 68 d1 ff ff       	call   80101eb0 <namei>
80104d48:	83 c4 10             	add    $0x10,%esp
80104d4b:	85 c0                	test   %eax,%eax
80104d4d:	89 c3                	mov    %eax,%ebx
80104d4f:	0f 84 f3 00 00 00    	je     80104e48 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d55:	83 ec 0c             	sub    $0xc,%esp
80104d58:	50                   	push   %eax
80104d59:	e8 22 c9 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80104d5e:	83 c4 10             	add    $0x10,%esp
80104d61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d66:	0f 84 c4 00 00 00    	je     80104e30 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d6c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d71:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d74:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d77:	53                   	push   %ebx
80104d78:	e8 53 c8 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80104d7d:	89 1c 24             	mov    %ebx,(%esp)
80104d80:	e8 db c9 ff ff       	call   80101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d85:	58                   	pop    %eax
80104d86:	5a                   	pop    %edx
80104d87:	57                   	push   %edi
80104d88:	ff 75 d0             	pushl  -0x30(%ebp)
80104d8b:	e8 40 d1 ff ff       	call   80101ed0 <nameiparent>
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	85 c0                	test   %eax,%eax
80104d95:	89 c6                	mov    %eax,%esi
80104d97:	74 5b                	je     80104df4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104d99:	83 ec 0c             	sub    $0xc,%esp
80104d9c:	50                   	push   %eax
80104d9d:	e8 de c8 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	8b 03                	mov    (%ebx),%eax
80104da7:	39 06                	cmp    %eax,(%esi)
80104da9:	75 3d                	jne    80104de8 <sys_link+0xe8>
80104dab:	83 ec 04             	sub    $0x4,%esp
80104dae:	ff 73 04             	pushl  0x4(%ebx)
80104db1:	57                   	push   %edi
80104db2:	56                   	push   %esi
80104db3:	e8 38 d0 ff ff       	call   80101df0 <dirlink>
80104db8:	83 c4 10             	add    $0x10,%esp
80104dbb:	85 c0                	test   %eax,%eax
80104dbd:	78 29                	js     80104de8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	56                   	push   %esi
80104dc3:	e8 28 cb ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104dc8:	89 1c 24             	mov    %ebx,(%esp)
80104dcb:	e8 e0 c9 ff ff       	call   801017b0 <iput>

  end_op();
80104dd0:	e8 7b de ff ff       	call   80102c50 <end_op>

  return 0;
80104dd5:	83 c4 10             	add    $0x10,%esp
80104dd8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ddd:	5b                   	pop    %ebx
80104dde:	5e                   	pop    %esi
80104ddf:	5f                   	pop    %edi
80104de0:	5d                   	pop    %ebp
80104de1:	c3                   	ret    
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	56                   	push   %esi
80104dec:	e8 ff ca ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104df1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104df4:	83 ec 0c             	sub    $0xc,%esp
80104df7:	53                   	push   %ebx
80104df8:	e8 83 c8 ff ff       	call   80101680 <ilock>
  ip->nlink--;
80104dfd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e02:	89 1c 24             	mov    %ebx,(%esp)
80104e05:	e8 c6 c7 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104e0a:	89 1c 24             	mov    %ebx,(%esp)
80104e0d:	e8 de ca ff ff       	call   801018f0 <iunlockput>
  end_op();
80104e12:	e8 39 de ff ff       	call   80102c50 <end_op>
  return -1;
80104e17:	83 c4 10             	add    $0x10,%esp
}
80104e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5f                   	pop    %edi
80104e25:	5d                   	pop    %ebp
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	53                   	push   %ebx
80104e34:	e8 b7 ca ff ff       	call   801018f0 <iunlockput>
    end_op();
80104e39:	e8 12 de ff ff       	call   80102c50 <end_op>
    return -1;
80104e3e:	83 c4 10             	add    $0x10,%esp
80104e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e46:	eb 92                	jmp    80104dda <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e48:	e8 03 de ff ff       	call   80102c50 <end_op>
    return -1;
80104e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e52:	eb 86                	jmp    80104dda <sys_link+0xda>
80104e54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e60 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e66:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e69:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e6c:	50                   	push   %eax
80104e6d:	6a 00                	push   $0x0
80104e6f:	e8 bc f9 ff ff       	call   80104830 <argstr>
80104e74:	83 c4 10             	add    $0x10,%esp
80104e77:	85 c0                	test   %eax,%eax
80104e79:	0f 88 82 01 00 00    	js     80105001 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e7f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e82:	e8 59 dd ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e87:	83 ec 08             	sub    $0x8,%esp
80104e8a:	53                   	push   %ebx
80104e8b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e8e:	e8 3d d0 ff ff       	call   80101ed0 <nameiparent>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e9b:	0f 84 6a 01 00 00    	je     8010500b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104ea1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ea4:	83 ec 0c             	sub    $0xc,%esp
80104ea7:	56                   	push   %esi
80104ea8:	e8 d3 c7 ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ead:	58                   	pop    %eax
80104eae:	5a                   	pop    %edx
80104eaf:	68 b4 76 10 80       	push   $0x801076b4
80104eb4:	53                   	push   %ebx
80104eb5:	e8 b6 cc ff ff       	call   80101b70 <namecmp>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	85 c0                	test   %eax,%eax
80104ebf:	0f 84 fc 00 00 00    	je     80104fc1 <sys_unlink+0x161>
80104ec5:	83 ec 08             	sub    $0x8,%esp
80104ec8:	68 b3 76 10 80       	push   $0x801076b3
80104ecd:	53                   	push   %ebx
80104ece:	e8 9d cc ff ff       	call   80101b70 <namecmp>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	0f 84 e3 00 00 00    	je     80104fc1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104ede:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ee1:	83 ec 04             	sub    $0x4,%esp
80104ee4:	50                   	push   %eax
80104ee5:	53                   	push   %ebx
80104ee6:	56                   	push   %esi
80104ee7:	e8 a4 cc ff ff       	call   80101b90 <dirlookup>
80104eec:	83 c4 10             	add    $0x10,%esp
80104eef:	85 c0                	test   %eax,%eax
80104ef1:	89 c3                	mov    %eax,%ebx
80104ef3:	0f 84 c8 00 00 00    	je     80104fc1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104ef9:	83 ec 0c             	sub    $0xc,%esp
80104efc:	50                   	push   %eax
80104efd:	e8 7e c7 ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
80104f02:	83 c4 10             	add    $0x10,%esp
80104f05:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f0a:	0f 8e 24 01 00 00    	jle    80105034 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f10:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f15:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f18:	74 66                	je     80104f80 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f1a:	83 ec 04             	sub    $0x4,%esp
80104f1d:	6a 10                	push   $0x10
80104f1f:	6a 00                	push   $0x0
80104f21:	56                   	push   %esi
80104f22:	e8 89 f5 ff ff       	call   801044b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f27:	6a 10                	push   $0x10
80104f29:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f2c:	56                   	push   %esi
80104f2d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f30:	e8 0b cb ff ff       	call   80101a40 <writei>
80104f35:	83 c4 20             	add    $0x20,%esp
80104f38:	83 f8 10             	cmp    $0x10,%eax
80104f3b:	0f 85 e6 00 00 00    	jne    80105027 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f46:	0f 84 9c 00 00 00    	je     80104fe8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f52:	e8 99 c9 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80104f57:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f5c:	89 1c 24             	mov    %ebx,(%esp)
80104f5f:	e8 6c c6 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104f64:	89 1c 24             	mov    %ebx,(%esp)
80104f67:	e8 84 c9 ff ff       	call   801018f0 <iunlockput>

  end_op();
80104f6c:	e8 df dc ff ff       	call   80102c50 <end_op>

  return 0;
80104f71:	83 c4 10             	add    $0x10,%esp
80104f74:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f79:	5b                   	pop    %ebx
80104f7a:	5e                   	pop    %esi
80104f7b:	5f                   	pop    %edi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f80:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f84:	76 94                	jbe    80104f1a <sys_unlink+0xba>
80104f86:	bf 20 00 00 00       	mov    $0x20,%edi
80104f8b:	eb 0f                	jmp    80104f9c <sys_unlink+0x13c>
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
80104f90:	83 c7 10             	add    $0x10,%edi
80104f93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f96:	0f 83 7e ff ff ff    	jae    80104f1a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f9c:	6a 10                	push   $0x10
80104f9e:	57                   	push   %edi
80104f9f:	56                   	push   %esi
80104fa0:	53                   	push   %ebx
80104fa1:	e8 9a c9 ff ff       	call   80101940 <readi>
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	83 f8 10             	cmp    $0x10,%eax
80104fac:	75 6c                	jne    8010501a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fae:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fb3:	74 db                	je     80104f90 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	53                   	push   %ebx
80104fb9:	e8 32 c9 ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104fbe:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fc1:	83 ec 0c             	sub    $0xc,%esp
80104fc4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fc7:	e8 24 c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104fcc:	e8 7f dc ff ff       	call   80102c50 <end_op>
  return -1;
80104fd1:	83 c4 10             	add    $0x10,%esp
}
80104fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fdc:	5b                   	pop    %ebx
80104fdd:	5e                   	pop    %esi
80104fde:	5f                   	pop    %edi
80104fdf:	5d                   	pop    %ebp
80104fe0:	c3                   	ret    
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fe8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104feb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fee:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104ff3:	50                   	push   %eax
80104ff4:	e8 d7 c5 ff ff       	call   801015d0 <iupdate>
80104ff9:	83 c4 10             	add    $0x10,%esp
80104ffc:	e9 4b ff ff ff       	jmp    80104f4c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105006:	e9 6b ff ff ff       	jmp    80104f76 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010500b:	e8 40 dc ff ff       	call   80102c50 <end_op>
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	e9 5c ff ff ff       	jmp    80104f76 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010501a:	83 ec 0c             	sub    $0xc,%esp
8010501d:	68 d8 76 10 80       	push   $0x801076d8
80105022:	e8 49 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105027:	83 ec 0c             	sub    $0xc,%esp
8010502a:	68 ea 76 10 80       	push   $0x801076ea
8010502f:	e8 3c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105034:	83 ec 0c             	sub    $0xc,%esp
80105037:	68 c6 76 10 80       	push   $0x801076c6
8010503c:	e8 2f b3 ff ff       	call   80100370 <panic>
80105041:	eb 0d                	jmp    80105050 <sys_open>
80105043:	90                   	nop
80105044:	90                   	nop
80105045:	90                   	nop
80105046:	90                   	nop
80105047:	90                   	nop
80105048:	90                   	nop
80105049:	90                   	nop
8010504a:	90                   	nop
8010504b:	90                   	nop
8010504c:	90                   	nop
8010504d:	90                   	nop
8010504e:	90                   	nop
8010504f:	90                   	nop

80105050 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
80105055:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105056:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105059:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010505c:	50                   	push   %eax
8010505d:	6a 00                	push   $0x0
8010505f:	e8 cc f7 ff ff       	call   80104830 <argstr>
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	85 c0                	test   %eax,%eax
80105069:	0f 88 9e 00 00 00    	js     8010510d <sys_open+0xbd>
8010506f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105072:	83 ec 08             	sub    $0x8,%esp
80105075:	50                   	push   %eax
80105076:	6a 01                	push   $0x1
80105078:	e8 23 f7 ff ff       	call   801047a0 <argint>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	0f 88 85 00 00 00    	js     8010510d <sys_open+0xbd>
    return -1;

  begin_op();
80105088:	e8 53 db ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
8010508d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105091:	0f 85 89 00 00 00    	jne    80105120 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105097:	83 ec 0c             	sub    $0xc,%esp
8010509a:	ff 75 e0             	pushl  -0x20(%ebp)
8010509d:	e8 0e ce ff ff       	call   80101eb0 <namei>
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	85 c0                	test   %eax,%eax
801050a7:	89 c7                	mov    %eax,%edi
801050a9:	0f 84 8e 00 00 00    	je     8010513d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050af:	83 ec 0c             	sub    $0xc,%esp
801050b2:	50                   	push   %eax
801050b3:	e8 c8 c5 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801050c0:	0f 84 d2 00 00 00    	je     80105198 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050c6:	e8 b5 bc ff ff       	call   80100d80 <filealloc>
801050cb:	85 c0                	test   %eax,%eax
801050cd:	89 c6                	mov    %eax,%esi
801050cf:	74 2b                	je     801050fc <sys_open+0xac>
801050d1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050d8:	31 db                	xor    %ebx,%ebx
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801050e0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801050e4:	85 c0                	test   %eax,%eax
801050e6:	74 68                	je     80105150 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801050e8:	83 c3 01             	add    $0x1,%ebx
801050eb:	83 fb 10             	cmp    $0x10,%ebx
801050ee:	75 f0                	jne    801050e0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050f0:	83 ec 0c             	sub    $0xc,%esp
801050f3:	56                   	push   %esi
801050f4:	e8 47 bd ff ff       	call   80100e40 <fileclose>
801050f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	57                   	push   %edi
80105100:	e8 eb c7 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105105:	e8 46 db ff ff       	call   80102c50 <end_op>
    return -1;
8010510a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010510d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5f                   	pop    %edi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret    
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105126:	31 c9                	xor    %ecx,%ecx
80105128:	6a 00                	push   $0x0
8010512a:	ba 02 00 00 00       	mov    $0x2,%edx
8010512f:	e8 ec f7 ff ff       	call   80104920 <create>
    if(ip == 0){
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105139:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010513b:	75 89                	jne    801050c6 <sys_open+0x76>
      end_op();
8010513d:	e8 0e db ff ff       	call   80102c50 <end_op>
      return -1;
80105142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105147:	eb 43                	jmp    8010518c <sys_open+0x13c>
80105149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105150:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105153:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105157:	57                   	push   %edi
80105158:	e8 03 c6 ff ff       	call   80101760 <iunlock>
  end_op();
8010515d:	e8 ee da ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
80105162:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105168:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010516b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010516e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105171:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105178:	89 d0                	mov    %edx,%eax
8010517a:	83 e0 01             	and    $0x1,%eax
8010517d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105180:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105183:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105186:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
8010518a:	89 d8                	mov    %ebx,%eax
}
8010518c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010518f:	5b                   	pop    %ebx
80105190:	5e                   	pop    %esi
80105191:	5f                   	pop    %edi
80105192:	5d                   	pop    %ebp
80105193:	c3                   	ret    
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105198:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010519b:	85 d2                	test   %edx,%edx
8010519d:	0f 84 23 ff ff ff    	je     801050c6 <sys_open+0x76>
801051a3:	e9 54 ff ff ff       	jmp    801050fc <sys_open+0xac>
801051a8:	90                   	nop
801051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051b0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051b6:	e8 25 da ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051be:	83 ec 08             	sub    $0x8,%esp
801051c1:	50                   	push   %eax
801051c2:	6a 00                	push   $0x0
801051c4:	e8 67 f6 ff ff       	call   80104830 <argstr>
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	85 c0                	test   %eax,%eax
801051ce:	78 30                	js     80105200 <sys_mkdir+0x50>
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d6:	31 c9                	xor    %ecx,%ecx
801051d8:	6a 00                	push   $0x0
801051da:	ba 01 00 00 00       	mov    $0x1,%edx
801051df:	e8 3c f7 ff ff       	call   80104920 <create>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	74 15                	je     80105200 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051eb:	83 ec 0c             	sub    $0xc,%esp
801051ee:	50                   	push   %eax
801051ef:	e8 fc c6 ff ff       	call   801018f0 <iunlockput>
  end_op();
801051f4:	e8 57 da ff ff       	call   80102c50 <end_op>
  return 0;
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	31 c0                	xor    %eax,%eax
}
801051fe:	c9                   	leave  
801051ff:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105200:	e8 4b da ff ff       	call   80102c50 <end_op>
    return -1;
80105205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010520a:	c9                   	leave  
8010520b:	c3                   	ret    
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_mknod>:

int
sys_mknod(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105216:	e8 c5 d9 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010521b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010521e:	83 ec 08             	sub    $0x8,%esp
80105221:	50                   	push   %eax
80105222:	6a 00                	push   $0x0
80105224:	e8 07 f6 ff ff       	call   80104830 <argstr>
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	85 c0                	test   %eax,%eax
8010522e:	78 60                	js     80105290 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105230:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105233:	83 ec 08             	sub    $0x8,%esp
80105236:	50                   	push   %eax
80105237:	6a 01                	push   $0x1
80105239:	e8 62 f5 ff ff       	call   801047a0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	85 c0                	test   %eax,%eax
80105243:	78 4b                	js     80105290 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105245:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105248:	83 ec 08             	sub    $0x8,%esp
8010524b:	50                   	push   %eax
8010524c:	6a 02                	push   $0x2
8010524e:	e8 4d f5 ff ff       	call   801047a0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	78 36                	js     80105290 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010525a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010525e:	83 ec 0c             	sub    $0xc,%esp
80105261:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105265:	ba 03 00 00 00       	mov    $0x3,%edx
8010526a:	50                   	push   %eax
8010526b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010526e:	e8 ad f6 ff ff       	call   80104920 <create>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	74 16                	je     80105290 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010527a:	83 ec 0c             	sub    $0xc,%esp
8010527d:	50                   	push   %eax
8010527e:	e8 6d c6 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105283:	e8 c8 d9 ff ff       	call   80102c50 <end_op>
  return 0;
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	31 c0                	xor    %eax,%eax
}
8010528d:	c9                   	leave  
8010528e:	c3                   	ret    
8010528f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105290:	e8 bb d9 ff ff       	call   80102c50 <end_op>
    return -1;
80105295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010529a:	c9                   	leave  
8010529b:	c3                   	ret    
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_chdir>:

int
sys_chdir(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052a7:	e8 34 d9 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052af:	83 ec 08             	sub    $0x8,%esp
801052b2:	50                   	push   %eax
801052b3:	6a 00                	push   $0x0
801052b5:	e8 76 f5 ff ff       	call   80104830 <argstr>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	85 c0                	test   %eax,%eax
801052bf:	78 7f                	js     80105340 <sys_chdir+0xa0>
801052c1:	83 ec 0c             	sub    $0xc,%esp
801052c4:	ff 75 f4             	pushl  -0xc(%ebp)
801052c7:	e8 e4 cb ff ff       	call   80101eb0 <namei>
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	85 c0                	test   %eax,%eax
801052d1:	89 c3                	mov    %eax,%ebx
801052d3:	74 6b                	je     80105340 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052d5:	83 ec 0c             	sub    $0xc,%esp
801052d8:	50                   	push   %eax
801052d9:	e8 a2 c3 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	75 38                	jne    80105320 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	53                   	push   %ebx
801052ec:	e8 6f c4 ff ff       	call   80101760 <iunlock>
  iput(proc->cwd);
801052f1:	58                   	pop    %eax
801052f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f8:	ff 70 68             	pushl  0x68(%eax)
801052fb:	e8 b0 c4 ff ff       	call   801017b0 <iput>
  end_op();
80105300:	e8 4b d9 ff ff       	call   80102c50 <end_op>
  proc->cwd = ip;
80105305:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010530b:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
8010530e:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105311:	31 c0                	xor    %eax,%eax
}
80105313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105316:	c9                   	leave  
80105317:	c3                   	ret    
80105318:	90                   	nop
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	53                   	push   %ebx
80105324:	e8 c7 c5 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105329:	e8 22 d9 ff ff       	call   80102c50 <end_op>
    return -1;
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105336:	eb db                	jmp    80105313 <sys_chdir+0x73>
80105338:	90                   	nop
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105340:	e8 0b d9 ff ff       	call   80102c50 <end_op>
    return -1;
80105345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534a:	eb c7                	jmp    80105313 <sys_chdir+0x73>
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105356:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010535c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105362:	50                   	push   %eax
80105363:	6a 00                	push   $0x0
80105365:	e8 c6 f4 ff ff       	call   80104830 <argstr>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	78 7f                	js     801053f0 <sys_exec+0xa0>
80105371:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105377:	83 ec 08             	sub    $0x8,%esp
8010537a:	50                   	push   %eax
8010537b:	6a 01                	push   $0x1
8010537d:	e8 1e f4 ff ff       	call   801047a0 <argint>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	85 c0                	test   %eax,%eax
80105387:	78 67                	js     801053f0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105389:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010538f:	83 ec 04             	sub    $0x4,%esp
80105392:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105398:	68 80 00 00 00       	push   $0x80
8010539d:	6a 00                	push   $0x0
8010539f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053a5:	50                   	push   %eax
801053a6:	31 db                	xor    %ebx,%ebx
801053a8:	e8 03 f1 ff ff       	call   801044b0 <memset>
801053ad:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053b0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053b6:	83 ec 08             	sub    $0x8,%esp
801053b9:	57                   	push   %edi
801053ba:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053bd:	50                   	push   %eax
801053be:	e8 5d f3 ff ff       	call   80104720 <fetchint>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	78 26                	js     801053f0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053ca:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053d0:	85 c0                	test   %eax,%eax
801053d2:	74 2c                	je     80105400 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053d4:	83 ec 08             	sub    $0x8,%esp
801053d7:	56                   	push   %esi
801053d8:	50                   	push   %eax
801053d9:	e8 72 f3 ff ff       	call   80104750 <fetchstr>
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 0b                	js     801053f0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053e5:	83 c3 01             	add    $0x1,%ebx
801053e8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053eb:	83 fb 20             	cmp    $0x20,%ebx
801053ee:	75 c0                	jne    801053b0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801053f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053f8:	5b                   	pop    %ebx
801053f9:	5e                   	pop    %esi
801053fa:	5f                   	pop    %edi
801053fb:	5d                   	pop    %ebp
801053fc:	c3                   	ret    
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105400:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105406:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105409:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105410:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105414:	50                   	push   %eax
80105415:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010541b:	e8 e0 b5 ff ff       	call   80100a00 <exec>
80105420:	83 c4 10             	add    $0x10,%esp
}
80105423:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105426:	5b                   	pop    %ebx
80105427:	5e                   	pop    %esi
80105428:	5f                   	pop    %edi
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	90                   	nop
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_pipe>:

int
sys_pipe(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105436:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105439:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010543c:	6a 08                	push   $0x8
8010543e:	50                   	push   %eax
8010543f:	6a 00                	push   $0x0
80105441:	e8 9a f3 ff ff       	call   801047e0 <argptr>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	78 48                	js     80105495 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010544d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105450:	83 ec 08             	sub    $0x8,%esp
80105453:	50                   	push   %eax
80105454:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105457:	50                   	push   %eax
80105458:	e8 23 df ff ff       	call   80103380 <pipealloc>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 31                	js     80105495 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105464:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105467:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010546e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105470:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105474:	85 d2                	test   %edx,%edx
80105476:	74 28                	je     801054a0 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 c0 01             	add    $0x1,%eax
8010547b:	83 f8 10             	cmp    $0x10,%eax
8010547e:	75 f0                	jne    80105470 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	53                   	push   %ebx
80105484:	e8 b7 b9 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105489:	58                   	pop    %eax
8010548a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010548d:	e8 ae b9 ff ff       	call   80100e40 <fileclose>
    return -1;
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	eb 45                	jmp    801054e1 <sys_pipe+0xb1>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054a0:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054a6:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054a8:	89 5e 28             	mov    %ebx,0x28(%esi)
801054ab:	90                   	nop
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801054b0:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801054b5:	74 19                	je     801054d0 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054b7:	83 c2 01             	add    $0x1,%edx
801054ba:	83 fa 10             	cmp    $0x10,%edx
801054bd:	75 f1                	jne    801054b0 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801054bf:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
801054c6:	eb b8                	jmp    80105480 <sys_pipe+0x50>
801054c8:	90                   	nop
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054d0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801054d7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801054d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801054df:	31 c0                	xor    %eax,%eax
}
801054e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e4:	5b                   	pop    %ebx
801054e5:	5e                   	pop    %esi
801054e6:	5f                   	pop    %edi
801054e7:	5d                   	pop    %ebp
801054e8:	c3                   	ret    
801054e9:	66 90                	xchg   %ax,%ax
801054eb:	66 90                	xchg   %ax,%ax
801054ed:	66 90                	xchg   %ax,%ax
801054ef:	90                   	nop

801054f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801054f4:	e9 07 e5 ff ff       	jmp    80103a00 <fork>
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exit>:
}

int
sys_exit(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 08             	sub    $0x8,%esp
  exit();
80105506:	e8 65 e7 ff ff       	call   80103c70 <exit>
  return 0;  // not reached
}
8010550b:	31 c0                	xor    %eax,%eax
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <sys_wait>:

int
sys_wait(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105513:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105514:	e9 a7 e9 ff ff       	jmp    80103ec0 <wait>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_kill>:
}

int
sys_kill(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105529:	50                   	push   %eax
8010552a:	6a 00                	push   $0x0
8010552c:	e8 6f f2 ff ff       	call   801047a0 <argint>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	85 c0                	test   %eax,%eax
80105536:	78 18                	js     80105550 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	e8 bd ea ff ff       	call   80104000 <kill>
80105543:	83 c4 10             	add    $0x10,%esp
}
80105546:	c9                   	leave  
80105547:	c3                   	ret    
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105560:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105566:	55                   	push   %ebp
80105567:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105569:	8b 40 10             	mov    0x10(%eax),%eax
}
8010556c:	5d                   	pop    %ebp
8010556d:	c3                   	ret    
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_sbrk>:

int
sys_sbrk(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
80105577:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 1e f2 ff ff       	call   801047a0 <argint>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 27                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105589:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010558f:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105592:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105594:	ff 75 f4             	pushl  -0xc(%ebp)
80105597:	e8 f4 e3 ff ff       	call   80103990 <growproc>
8010559c:	83 c4 10             	add    $0x10,%esp
8010559f:	85 c0                	test   %eax,%eax
801055a1:	78 0d                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055a3:	89 d8                	mov    %ebx,%eax
}
801055a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a8:	c9                   	leave  
801055a9:	c3                   	ret    
801055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb ee                	jmp    801055a5 <sys_sbrk+0x35>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055c7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ca:	50                   	push   %eax
801055cb:	6a 00                	push   $0x0
801055cd:	e8 ce f1 ff ff       	call   801047a0 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	0f 88 8a 00 00 00    	js     80105667 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	68 e0 4c 11 80       	push   $0x80114ce0
801055e5:	e8 96 ec ff ff       	call   80104280 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ed:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801055f0:	8b 1d 20 55 11 80    	mov    0x80115520,%ebx
  while(ticks - ticks0 < n){
801055f6:	85 d2                	test   %edx,%edx
801055f8:	75 27                	jne    80105621 <sys_sleep+0x61>
801055fa:	eb 54                	jmp    80105650 <sys_sleep+0x90>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	68 e0 4c 11 80       	push   $0x80114ce0
80105608:	68 20 55 11 80       	push   $0x80115520
8010560d:	e8 ee e7 ff ff       	call   80103e00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105612:	a1 20 55 11 80       	mov    0x80115520,%eax
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	29 d8                	sub    %ebx,%eax
8010561c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010561f:	73 2f                	jae    80105650 <sys_sleep+0x90>
    if(proc->killed){
80105621:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105627:	8b 40 24             	mov    0x24(%eax),%eax
8010562a:	85 c0                	test   %eax,%eax
8010562c:	74 d2                	je     80105600 <sys_sleep+0x40>
      release(&tickslock);
8010562e:	83 ec 0c             	sub    $0xc,%esp
80105631:	68 e0 4c 11 80       	push   $0x80114ce0
80105636:	e8 25 ee ff ff       	call   80104460 <release>
      return -1;
8010563b:	83 c4 10             	add    $0x10,%esp
8010563e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105646:	c9                   	leave  
80105647:	c3                   	ret    
80105648:	90                   	nop
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	68 e0 4c 11 80       	push   $0x80114ce0
80105658:	e8 03 ee ff ff       	call   80104460 <release>
  return 0;
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	31 c0                	xor    %eax,%eax
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb d5                	jmp    80105643 <sys_sleep+0x83>
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
80105674:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105677:	68 e0 4c 11 80       	push   $0x80114ce0
8010567c:	e8 ff eb ff ff       	call   80104280 <acquire>
  xticks = ticks;
80105681:	8b 1d 20 55 11 80    	mov    0x80115520,%ebx
  release(&tickslock);
80105687:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
8010568e:	e8 cd ed ff ff       	call   80104460 <release>
  return xticks;
}
80105693:	89 d8                	mov    %ebx,%eax
80105695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105698:	c9                   	leave  
80105699:	c3                   	ret    
8010569a:	66 90                	xchg   %ax,%ax
8010569c:	66 90                	xchg   %ax,%ax
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801056a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056a1:	ba 43 00 00 00       	mov    $0x43,%edx
801056a6:	b8 34 00 00 00       	mov    $0x34,%eax
801056ab:	89 e5                	mov    %esp,%ebp
801056ad:	83 ec 14             	sub    $0x14,%esp
801056b0:	ee                   	out    %al,(%dx)
801056b1:	ba 40 00 00 00       	mov    $0x40,%edx
801056b6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801056bb:	ee                   	out    %al,(%dx)
801056bc:	b8 2e 00 00 00       	mov    $0x2e,%eax
801056c1:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801056c2:	6a 00                	push   $0x0
801056c4:	e8 e7 db ff ff       	call   801032b0 <picenable>
}
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	c9                   	leave  
801056cd:	c3                   	ret    

801056ce <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801056ce:	1e                   	push   %ds
  pushl %es
801056cf:	06                   	push   %es
  pushl %fs
801056d0:	0f a0                	push   %fs
  pushl %gs
801056d2:	0f a8                	push   %gs
  pushal
801056d4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801056d5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056d9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056db:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801056dd:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801056e1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801056e3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801056e5:	54                   	push   %esp
  call trap
801056e6:	e8 e5 00 00 00       	call   801057d0 <trap>
  addl $4, %esp
801056eb:	83 c4 04             	add    $0x4,%esp

801056ee <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056ee:	61                   	popa   
  popl %gs
801056ef:	0f a9                	pop    %gs
  popl %fs
801056f1:	0f a1                	pop    %fs
  popl %es
801056f3:	07                   	pop    %es
  popl %ds
801056f4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056f5:	83 c4 08             	add    $0x8,%esp
  iret
801056f8:	cf                   	iret   
801056f9:	66 90                	xchg   %ax,%ax
801056fb:	66 90                	xchg   %ax,%ax
801056fd:	66 90                	xchg   %ax,%ax
801056ff:	90                   	nop

80105700 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105700:	31 c0                	xor    %eax,%eax
80105702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105708:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010570f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105714:	c6 04 c5 24 4d 11 80 	movb   $0x0,-0x7feeb2dc(,%eax,8)
8010571b:	00 
8010571c:	66 89 0c c5 22 4d 11 	mov    %cx,-0x7feeb2de(,%eax,8)
80105723:	80 
80105724:	c6 04 c5 25 4d 11 80 	movb   $0x8e,-0x7feeb2db(,%eax,8)
8010572b:	8e 
8010572c:	66 89 14 c5 20 4d 11 	mov    %dx,-0x7feeb2e0(,%eax,8)
80105733:	80 
80105734:	c1 ea 10             	shr    $0x10,%edx
80105737:	66 89 14 c5 26 4d 11 	mov    %dx,-0x7feeb2da(,%eax,8)
8010573e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010573f:	83 c0 01             	add    $0x1,%eax
80105742:	3d 00 01 00 00       	cmp    $0x100,%eax
80105747:	75 bf                	jne    80105708 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105749:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010574a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010574f:	89 e5                	mov    %esp,%ebp
80105751:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105754:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105759:	68 f9 76 10 80       	push   $0x801076f9
8010575e:	68 e0 4c 11 80       	push   $0x80114ce0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105763:	66 89 15 22 4f 11 80 	mov    %dx,0x80114f22
8010576a:	c6 05 24 4f 11 80 00 	movb   $0x0,0x80114f24
80105771:	66 a3 20 4f 11 80    	mov    %ax,0x80114f20
80105777:	c1 e8 10             	shr    $0x10,%eax
8010577a:	c6 05 25 4f 11 80 ef 	movb   $0xef,0x80114f25
80105781:	66 a3 26 4f 11 80    	mov    %ax,0x80114f26

  initlock(&tickslock, "time");
80105787:	e8 d4 ea ff ff       	call   80104260 <initlock>
}
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	c9                   	leave  
80105790:	c3                   	ret    
80105791:	eb 0d                	jmp    801057a0 <idtinit>
80105793:	90                   	nop
80105794:	90                   	nop
80105795:	90                   	nop
80105796:	90                   	nop
80105797:	90                   	nop
80105798:	90                   	nop
80105799:	90                   	nop
8010579a:	90                   	nop
8010579b:	90                   	nop
8010579c:	90                   	nop
8010579d:	90                   	nop
8010579e:	90                   	nop
8010579f:	90                   	nop

801057a0 <idtinit>:

void
idtinit(void)
{
801057a0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801057a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057a6:	89 e5                	mov    %esp,%ebp
801057a8:	83 ec 10             	sub    $0x10,%esp
801057ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057af:	b8 20 4d 11 80       	mov    $0x80114d20,%eax
801057b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057b8:	c1 e8 10             	shr    $0x10,%eax
801057bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801057bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
801057d6:	83 ec 0c             	sub    $0xc,%esp
801057d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801057dc:	8b 43 30             	mov    0x30(%ebx),%eax
801057df:	83 f8 40             	cmp    $0x40,%eax
801057e2:	0f 84 f8 00 00 00    	je     801058e0 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801057e8:	83 e8 20             	sub    $0x20,%eax
801057eb:	83 f8 1f             	cmp    $0x1f,%eax
801057ee:	77 68                	ja     80105858 <trap+0x88>
801057f0:	ff 24 85 a0 77 10 80 	jmp    *-0x7fef8860(,%eax,4)
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105800:	e8 fb ce ff ff       	call   80102700 <cpunum>
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 84 b3 01 00 00    	je     801059c0 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010580d:	e8 8e cf ff ff       	call   801027a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105818:	85 c0                	test   %eax,%eax
8010581a:	74 2d                	je     80105849 <trap+0x79>
8010581c:	8b 50 24             	mov    0x24(%eax),%edx
8010581f:	85 d2                	test   %edx,%edx
80105821:	0f 85 86 00 00 00    	jne    801058ad <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105827:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010582b:	0f 84 ef 00 00 00    	je     80105920 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105831:	8b 40 24             	mov    0x24(%eax),%eax
80105834:	85 c0                	test   %eax,%eax
80105836:	74 11                	je     80105849 <trap+0x79>
80105838:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010583c:	83 e0 03             	and    $0x3,%eax
8010583f:	66 83 f8 03          	cmp    $0x3,%ax
80105843:	0f 84 c1 00 00 00    	je     8010590a <trap+0x13a>
    exit();
}
80105849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010584c:	5b                   	pop    %ebx
8010584d:	5e                   	pop    %esi
8010584e:	5f                   	pop    %edi
8010584f:	5d                   	pop    %ebp
80105850:	c3                   	ret    
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105858:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010585f:	85 c9                	test   %ecx,%ecx
80105861:	0f 84 8d 01 00 00    	je     801059f4 <trap+0x224>
80105867:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010586b:	0f 84 83 01 00 00    	je     801059f4 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105871:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105874:	8b 73 38             	mov    0x38(%ebx),%esi
80105877:	e8 84 ce ff ff       	call   80102700 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010587c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
80105885:	50                   	push   %eax
80105886:	ff 73 34             	pushl  0x34(%ebx)
80105889:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010588c:	8d 42 6c             	lea    0x6c(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010588f:	50                   	push   %eax
80105890:	ff 72 10             	pushl  0x10(%edx)
80105893:	68 5c 77 10 80       	push   $0x8010775c
80105898:	e8 c3 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010589d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058a3:	83 c4 20             	add    $0x20,%esp
801058a6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058ad:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
801058b1:	83 e2 03             	and    $0x3,%edx
801058b4:	66 83 fa 03          	cmp    $0x3,%dx
801058b8:	0f 85 69 ff ff ff    	jne    80105827 <trap+0x57>
    exit();
801058be:	e8 ad e3 ff ff       	call   80103c70 <exit>
801058c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801058c9:	85 c0                	test   %eax,%eax
801058cb:	0f 85 56 ff ff ff    	jne    80105827 <trap+0x57>
801058d1:	e9 73 ff ff ff       	jmp    80105849 <trap+0x79>
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
801058e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058e6:	8b 70 24             	mov    0x24(%eax),%esi
801058e9:	85 f6                	test   %esi,%esi
801058eb:	0f 85 bf 00 00 00    	jne    801059b0 <trap+0x1e0>
      exit();
    proc->tf = tf;
801058f1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801058f4:	e8 b7 ef ff ff       	call   801048b0 <syscall>
    if(proc->killed)
801058f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ff:	8b 58 24             	mov    0x24(%eax),%ebx
80105902:	85 db                	test   %ebx,%ebx
80105904:	0f 84 3f ff ff ff    	je     80105849 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010590a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010590d:	5b                   	pop    %ebx
8010590e:	5e                   	pop    %esi
8010590f:	5f                   	pop    %edi
80105910:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105911:	e9 5a e3 ff ff       	jmp    80103c70 <exit>
80105916:	8d 76 00             	lea    0x0(%esi),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105920:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105924:	0f 85 07 ff ff ff    	jne    80105831 <trap+0x61>
    yield();
8010592a:	e8 91 e4 ff ff       	call   80103dc0 <yield>
8010592f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105935:	85 c0                	test   %eax,%eax
80105937:	0f 85 f4 fe ff ff    	jne    80105831 <trap+0x61>
8010593d:	e9 07 ff ff ff       	jmp    80105849 <trap+0x79>
80105942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105948:	e8 93 cc ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
8010594d:	e8 4e ce ff ff       	call   801027a0 <lapiceoi>
    break;
80105952:	e9 bb fe ff ff       	jmp    80105812 <trap+0x42>
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105960:	e8 2b 02 00 00       	call   80105b90 <uartintr>
80105965:	e9 a3 fe ff ff       	jmp    8010580d <trap+0x3d>
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105970:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105974:	8b 7b 38             	mov    0x38(%ebx),%edi
80105977:	e8 84 cd ff ff       	call   80102700 <cpunum>
8010597c:	57                   	push   %edi
8010597d:	56                   	push   %esi
8010597e:	50                   	push   %eax
8010597f:	68 04 77 10 80       	push   $0x80107704
80105984:	e8 d7 ac ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105989:	e8 12 ce ff ff       	call   801027a0 <lapiceoi>
    break;
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	e9 7c fe ff ff       	jmp    80105812 <trap+0x42>
80105996:	8d 76 00             	lea    0x0(%esi),%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059a0:	e8 ab c6 ff ff       	call   80102050 <ideintr>
    lapiceoi();
801059a5:	e8 f6 cd ff ff       	call   801027a0 <lapiceoi>
    break;
801059aa:	e9 63 fe ff ff       	jmp    80105812 <trap+0x42>
801059af:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
801059b0:	e8 bb e2 ff ff       	call   80103c70 <exit>
801059b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059bb:	e9 31 ff ff ff       	jmp    801058f1 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	68 e0 4c 11 80       	push   $0x80114ce0
801059c8:	e8 b3 e8 ff ff       	call   80104280 <acquire>
      ticks++;
      wakeup(&ticks);
801059cd:	c7 04 24 20 55 11 80 	movl   $0x80115520,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
801059d4:	83 05 20 55 11 80 01 	addl   $0x1,0x80115520
      wakeup(&ticks);
801059db:	e8 c0 e5 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
801059e0:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
801059e7:	e8 74 ea ff ff       	call   80104460 <release>
801059ec:	83 c4 10             	add    $0x10,%esp
801059ef:	e9 19 fe ff ff       	jmp    8010580d <trap+0x3d>
801059f4:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059f7:	8b 73 38             	mov    0x38(%ebx),%esi
801059fa:	e8 01 cd ff ff       	call   80102700 <cpunum>
801059ff:	83 ec 0c             	sub    $0xc,%esp
80105a02:	57                   	push   %edi
80105a03:	56                   	push   %esi
80105a04:	50                   	push   %eax
80105a05:	ff 73 30             	pushl  0x30(%ebx)
80105a08:	68 28 77 10 80       	push   $0x80107728
80105a0d:	e8 4e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105a12:	83 c4 14             	add    $0x14,%esp
80105a15:	68 fe 76 10 80       	push   $0x801076fe
80105a1a:	e8 51 a9 ff ff       	call   80100370 <panic>
80105a1f:	90                   	nop

80105a20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a20:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a25:	55                   	push   %ebp
80105a26:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a28:	85 c0                	test   %eax,%eax
80105a2a:	74 1c                	je     80105a48 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a2c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a31:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a32:	a8 01                	test   $0x1,%al
80105a34:	74 12                	je     80105a48 <uartgetc+0x28>
80105a36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a3b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a3c:	0f b6 c0             	movzbl %al,%eax
}
80105a3f:	5d                   	pop    %ebp
80105a40:	c3                   	ret    
80105a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a4d:	5d                   	pop    %ebp
80105a4e:	c3                   	ret    
80105a4f:	90                   	nop

80105a50 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	57                   	push   %edi
80105a54:	56                   	push   %esi
80105a55:	53                   	push   %ebx
80105a56:	89 c7                	mov    %eax,%edi
80105a58:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a62:	83 ec 0c             	sub    $0xc,%esp
80105a65:	eb 1b                	jmp    80105a82 <uartputc.part.0+0x32>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	6a 0a                	push   $0xa
80105a75:	e8 46 cd ff ff       	call   801027c0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	83 eb 01             	sub    $0x1,%ebx
80105a80:	74 07                	je     80105a89 <uartputc.part.0+0x39>
80105a82:	89 f2                	mov    %esi,%edx
80105a84:	ec                   	in     (%dx),%al
80105a85:	a8 20                	test   $0x20,%al
80105a87:	74 e7                	je     80105a70 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a89:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a8e:	89 f8                	mov    %edi,%eax
80105a90:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a94:	5b                   	pop    %ebx
80105a95:	5e                   	pop    %esi
80105a96:	5f                   	pop    %edi
80105a97:	5d                   	pop    %ebp
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	31 c9                	xor    %ecx,%ecx
80105aa3:	89 c8                	mov    %ecx,%eax
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	57                   	push   %edi
80105aa8:	56                   	push   %esi
80105aa9:	53                   	push   %ebx
80105aaa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105aaf:	89 da                	mov    %ebx,%edx
80105ab1:	83 ec 0c             	sub    $0xc,%esp
80105ab4:	ee                   	out    %al,(%dx)
80105ab5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105aba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105abf:	89 fa                	mov    %edi,%edx
80105ac1:	ee                   	out    %al,(%dx)
80105ac2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ac7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105acc:	ee                   	out    %al,(%dx)
80105acd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ad2:	89 c8                	mov    %ecx,%eax
80105ad4:	89 f2                	mov    %esi,%edx
80105ad6:	ee                   	out    %al,(%dx)
80105ad7:	b8 03 00 00 00       	mov    $0x3,%eax
80105adc:	89 fa                	mov    %edi,%edx
80105ade:	ee                   	out    %al,(%dx)
80105adf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ae4:	89 c8                	mov    %ecx,%eax
80105ae6:	ee                   	out    %al,(%dx)
80105ae7:	b8 01 00 00 00       	mov    $0x1,%eax
80105aec:	89 f2                	mov    %esi,%edx
80105aee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105af4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105af5:	3c ff                	cmp    $0xff,%al
80105af7:	74 5a                	je     80105b53 <uartinit+0xb3>
    return;
  uart = 1;
80105af9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105b00:	00 00 00 
80105b03:	89 da                	mov    %ebx,%edx
80105b05:	ec                   	in     (%dx),%al
80105b06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b0b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	6a 04                	push   $0x4
80105b11:	e8 9a d7 ff ff       	call   801032b0 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105b16:	59                   	pop    %ecx
80105b17:	5b                   	pop    %ebx
80105b18:	6a 00                	push   $0x0
80105b1a:	6a 04                	push   $0x4
80105b1c:	bb 20 78 10 80       	mov    $0x80107820,%ebx
80105b21:	e8 8a c7 ff ff       	call   801022b0 <ioapicenable>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	b8 78 00 00 00       	mov    $0x78,%eax
80105b2e:	eb 0a                	jmp    80105b3a <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	0f be 03             	movsbl (%ebx),%eax
80105b36:	84 c0                	test   %al,%al
80105b38:	74 19                	je     80105b53 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b3a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105b40:	85 d2                	test   %edx,%edx
80105b42:	74 ec                	je     80105b30 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b44:	83 c3 01             	add    $0x1,%ebx
80105b47:	e8 04 ff ff ff       	call   80105a50 <uartputc.part.0>
80105b4c:	0f be 03             	movsbl (%ebx),%eax
80105b4f:	84 c0                	test   %al,%al
80105b51:	75 e7                	jne    80105b3a <uartinit+0x9a>
    uartputc(*p);
}
80105b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b56:	5b                   	pop    %ebx
80105b57:	5e                   	pop    %esi
80105b58:	5f                   	pop    %edi
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    
80105b5b:	90                   	nop
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b60:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b66:	55                   	push   %ebp
80105b67:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b69:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b6e:	74 10                	je     80105b80 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b70:	5d                   	pop    %ebp
80105b71:	e9 da fe ff ff       	jmp    80105a50 <uartputc.part.0>
80105b76:	8d 76 00             	lea    0x0(%esi),%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b80:	5d                   	pop    %ebp
80105b81:	c3                   	ret    
80105b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b90 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b96:	68 20 5a 10 80       	push   $0x80105a20
80105b9b:	e8 50 ac ff ff       	call   801007f0 <consoleintr>
}
80105ba0:	83 c4 10             	add    $0x10,%esp
80105ba3:	c9                   	leave  
80105ba4:	c3                   	ret    

80105ba5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $0
80105ba7:	6a 00                	push   $0x0
  jmp alltraps
80105ba9:	e9 20 fb ff ff       	jmp    801056ce <alltraps>

80105bae <vector1>:
.globl vector1
vector1:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $1
80105bb0:	6a 01                	push   $0x1
  jmp alltraps
80105bb2:	e9 17 fb ff ff       	jmp    801056ce <alltraps>

80105bb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $2
80105bb9:	6a 02                	push   $0x2
  jmp alltraps
80105bbb:	e9 0e fb ff ff       	jmp    801056ce <alltraps>

80105bc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $3
80105bc2:	6a 03                	push   $0x3
  jmp alltraps
80105bc4:	e9 05 fb ff ff       	jmp    801056ce <alltraps>

80105bc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $4
80105bcb:	6a 04                	push   $0x4
  jmp alltraps
80105bcd:	e9 fc fa ff ff       	jmp    801056ce <alltraps>

80105bd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $5
80105bd4:	6a 05                	push   $0x5
  jmp alltraps
80105bd6:	e9 f3 fa ff ff       	jmp    801056ce <alltraps>

80105bdb <vector6>:
.globl vector6
vector6:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $6
80105bdd:	6a 06                	push   $0x6
  jmp alltraps
80105bdf:	e9 ea fa ff ff       	jmp    801056ce <alltraps>

80105be4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $7
80105be6:	6a 07                	push   $0x7
  jmp alltraps
80105be8:	e9 e1 fa ff ff       	jmp    801056ce <alltraps>

80105bed <vector8>:
.globl vector8
vector8:
  pushl $8
80105bed:	6a 08                	push   $0x8
  jmp alltraps
80105bef:	e9 da fa ff ff       	jmp    801056ce <alltraps>

80105bf4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $9
80105bf6:	6a 09                	push   $0x9
  jmp alltraps
80105bf8:	e9 d1 fa ff ff       	jmp    801056ce <alltraps>

80105bfd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bfd:	6a 0a                	push   $0xa
  jmp alltraps
80105bff:	e9 ca fa ff ff       	jmp    801056ce <alltraps>

80105c04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c04:	6a 0b                	push   $0xb
  jmp alltraps
80105c06:	e9 c3 fa ff ff       	jmp    801056ce <alltraps>

80105c0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c0b:	6a 0c                	push   $0xc
  jmp alltraps
80105c0d:	e9 bc fa ff ff       	jmp    801056ce <alltraps>

80105c12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c12:	6a 0d                	push   $0xd
  jmp alltraps
80105c14:	e9 b5 fa ff ff       	jmp    801056ce <alltraps>

80105c19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c19:	6a 0e                	push   $0xe
  jmp alltraps
80105c1b:	e9 ae fa ff ff       	jmp    801056ce <alltraps>

80105c20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $15
80105c22:	6a 0f                	push   $0xf
  jmp alltraps
80105c24:	e9 a5 fa ff ff       	jmp    801056ce <alltraps>

80105c29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $16
80105c2b:	6a 10                	push   $0x10
  jmp alltraps
80105c2d:	e9 9c fa ff ff       	jmp    801056ce <alltraps>

80105c32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c32:	6a 11                	push   $0x11
  jmp alltraps
80105c34:	e9 95 fa ff ff       	jmp    801056ce <alltraps>

80105c39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $18
80105c3b:	6a 12                	push   $0x12
  jmp alltraps
80105c3d:	e9 8c fa ff ff       	jmp    801056ce <alltraps>

80105c42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $19
80105c44:	6a 13                	push   $0x13
  jmp alltraps
80105c46:	e9 83 fa ff ff       	jmp    801056ce <alltraps>

80105c4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $20
80105c4d:	6a 14                	push   $0x14
  jmp alltraps
80105c4f:	e9 7a fa ff ff       	jmp    801056ce <alltraps>

80105c54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $21
80105c56:	6a 15                	push   $0x15
  jmp alltraps
80105c58:	e9 71 fa ff ff       	jmp    801056ce <alltraps>

80105c5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c5d:	6a 00                	push   $0x0
  pushl $22
80105c5f:	6a 16                	push   $0x16
  jmp alltraps
80105c61:	e9 68 fa ff ff       	jmp    801056ce <alltraps>

80105c66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $23
80105c68:	6a 17                	push   $0x17
  jmp alltraps
80105c6a:	e9 5f fa ff ff       	jmp    801056ce <alltraps>

80105c6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $24
80105c71:	6a 18                	push   $0x18
  jmp alltraps
80105c73:	e9 56 fa ff ff       	jmp    801056ce <alltraps>

80105c78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c78:	6a 00                	push   $0x0
  pushl $25
80105c7a:	6a 19                	push   $0x19
  jmp alltraps
80105c7c:	e9 4d fa ff ff       	jmp    801056ce <alltraps>

80105c81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c81:	6a 00                	push   $0x0
  pushl $26
80105c83:	6a 1a                	push   $0x1a
  jmp alltraps
80105c85:	e9 44 fa ff ff       	jmp    801056ce <alltraps>

80105c8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $27
80105c8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c8e:	e9 3b fa ff ff       	jmp    801056ce <alltraps>

80105c93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $28
80105c95:	6a 1c                	push   $0x1c
  jmp alltraps
80105c97:	e9 32 fa ff ff       	jmp    801056ce <alltraps>

80105c9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c9c:	6a 00                	push   $0x0
  pushl $29
80105c9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105ca0:	e9 29 fa ff ff       	jmp    801056ce <alltraps>

80105ca5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ca5:	6a 00                	push   $0x0
  pushl $30
80105ca7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ca9:	e9 20 fa ff ff       	jmp    801056ce <alltraps>

80105cae <vector31>:
.globl vector31
vector31:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $31
80105cb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105cb2:	e9 17 fa ff ff       	jmp    801056ce <alltraps>

80105cb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $32
80105cb9:	6a 20                	push   $0x20
  jmp alltraps
80105cbb:	e9 0e fa ff ff       	jmp    801056ce <alltraps>

80105cc0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105cc0:	6a 00                	push   $0x0
  pushl $33
80105cc2:	6a 21                	push   $0x21
  jmp alltraps
80105cc4:	e9 05 fa ff ff       	jmp    801056ce <alltraps>

80105cc9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $34
80105ccb:	6a 22                	push   $0x22
  jmp alltraps
80105ccd:	e9 fc f9 ff ff       	jmp    801056ce <alltraps>

80105cd2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $35
80105cd4:	6a 23                	push   $0x23
  jmp alltraps
80105cd6:	e9 f3 f9 ff ff       	jmp    801056ce <alltraps>

80105cdb <vector36>:
.globl vector36
vector36:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $36
80105cdd:	6a 24                	push   $0x24
  jmp alltraps
80105cdf:	e9 ea f9 ff ff       	jmp    801056ce <alltraps>

80105ce4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $37
80105ce6:	6a 25                	push   $0x25
  jmp alltraps
80105ce8:	e9 e1 f9 ff ff       	jmp    801056ce <alltraps>

80105ced <vector38>:
.globl vector38
vector38:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $38
80105cef:	6a 26                	push   $0x26
  jmp alltraps
80105cf1:	e9 d8 f9 ff ff       	jmp    801056ce <alltraps>

80105cf6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $39
80105cf8:	6a 27                	push   $0x27
  jmp alltraps
80105cfa:	e9 cf f9 ff ff       	jmp    801056ce <alltraps>

80105cff <vector40>:
.globl vector40
vector40:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $40
80105d01:	6a 28                	push   $0x28
  jmp alltraps
80105d03:	e9 c6 f9 ff ff       	jmp    801056ce <alltraps>

80105d08 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $41
80105d0a:	6a 29                	push   $0x29
  jmp alltraps
80105d0c:	e9 bd f9 ff ff       	jmp    801056ce <alltraps>

80105d11 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $42
80105d13:	6a 2a                	push   $0x2a
  jmp alltraps
80105d15:	e9 b4 f9 ff ff       	jmp    801056ce <alltraps>

80105d1a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $43
80105d1c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d1e:	e9 ab f9 ff ff       	jmp    801056ce <alltraps>

80105d23 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $44
80105d25:	6a 2c                	push   $0x2c
  jmp alltraps
80105d27:	e9 a2 f9 ff ff       	jmp    801056ce <alltraps>

80105d2c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $45
80105d2e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d30:	e9 99 f9 ff ff       	jmp    801056ce <alltraps>

80105d35 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $46
80105d37:	6a 2e                	push   $0x2e
  jmp alltraps
80105d39:	e9 90 f9 ff ff       	jmp    801056ce <alltraps>

80105d3e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $47
80105d40:	6a 2f                	push   $0x2f
  jmp alltraps
80105d42:	e9 87 f9 ff ff       	jmp    801056ce <alltraps>

80105d47 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $48
80105d49:	6a 30                	push   $0x30
  jmp alltraps
80105d4b:	e9 7e f9 ff ff       	jmp    801056ce <alltraps>

80105d50 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $49
80105d52:	6a 31                	push   $0x31
  jmp alltraps
80105d54:	e9 75 f9 ff ff       	jmp    801056ce <alltraps>

80105d59 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $50
80105d5b:	6a 32                	push   $0x32
  jmp alltraps
80105d5d:	e9 6c f9 ff ff       	jmp    801056ce <alltraps>

80105d62 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $51
80105d64:	6a 33                	push   $0x33
  jmp alltraps
80105d66:	e9 63 f9 ff ff       	jmp    801056ce <alltraps>

80105d6b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $52
80105d6d:	6a 34                	push   $0x34
  jmp alltraps
80105d6f:	e9 5a f9 ff ff       	jmp    801056ce <alltraps>

80105d74 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $53
80105d76:	6a 35                	push   $0x35
  jmp alltraps
80105d78:	e9 51 f9 ff ff       	jmp    801056ce <alltraps>

80105d7d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $54
80105d7f:	6a 36                	push   $0x36
  jmp alltraps
80105d81:	e9 48 f9 ff ff       	jmp    801056ce <alltraps>

80105d86 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $55
80105d88:	6a 37                	push   $0x37
  jmp alltraps
80105d8a:	e9 3f f9 ff ff       	jmp    801056ce <alltraps>

80105d8f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $56
80105d91:	6a 38                	push   $0x38
  jmp alltraps
80105d93:	e9 36 f9 ff ff       	jmp    801056ce <alltraps>

80105d98 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $57
80105d9a:	6a 39                	push   $0x39
  jmp alltraps
80105d9c:	e9 2d f9 ff ff       	jmp    801056ce <alltraps>

80105da1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $58
80105da3:	6a 3a                	push   $0x3a
  jmp alltraps
80105da5:	e9 24 f9 ff ff       	jmp    801056ce <alltraps>

80105daa <vector59>:
.globl vector59
vector59:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $59
80105dac:	6a 3b                	push   $0x3b
  jmp alltraps
80105dae:	e9 1b f9 ff ff       	jmp    801056ce <alltraps>

80105db3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $60
80105db5:	6a 3c                	push   $0x3c
  jmp alltraps
80105db7:	e9 12 f9 ff ff       	jmp    801056ce <alltraps>

80105dbc <vector61>:
.globl vector61
vector61:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $61
80105dbe:	6a 3d                	push   $0x3d
  jmp alltraps
80105dc0:	e9 09 f9 ff ff       	jmp    801056ce <alltraps>

80105dc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $62
80105dc7:	6a 3e                	push   $0x3e
  jmp alltraps
80105dc9:	e9 00 f9 ff ff       	jmp    801056ce <alltraps>

80105dce <vector63>:
.globl vector63
vector63:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $63
80105dd0:	6a 3f                	push   $0x3f
  jmp alltraps
80105dd2:	e9 f7 f8 ff ff       	jmp    801056ce <alltraps>

80105dd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $64
80105dd9:	6a 40                	push   $0x40
  jmp alltraps
80105ddb:	e9 ee f8 ff ff       	jmp    801056ce <alltraps>

80105de0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $65
80105de2:	6a 41                	push   $0x41
  jmp alltraps
80105de4:	e9 e5 f8 ff ff       	jmp    801056ce <alltraps>

80105de9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $66
80105deb:	6a 42                	push   $0x42
  jmp alltraps
80105ded:	e9 dc f8 ff ff       	jmp    801056ce <alltraps>

80105df2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $67
80105df4:	6a 43                	push   $0x43
  jmp alltraps
80105df6:	e9 d3 f8 ff ff       	jmp    801056ce <alltraps>

80105dfb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $68
80105dfd:	6a 44                	push   $0x44
  jmp alltraps
80105dff:	e9 ca f8 ff ff       	jmp    801056ce <alltraps>

80105e04 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $69
80105e06:	6a 45                	push   $0x45
  jmp alltraps
80105e08:	e9 c1 f8 ff ff       	jmp    801056ce <alltraps>

80105e0d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $70
80105e0f:	6a 46                	push   $0x46
  jmp alltraps
80105e11:	e9 b8 f8 ff ff       	jmp    801056ce <alltraps>

80105e16 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $71
80105e18:	6a 47                	push   $0x47
  jmp alltraps
80105e1a:	e9 af f8 ff ff       	jmp    801056ce <alltraps>

80105e1f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $72
80105e21:	6a 48                	push   $0x48
  jmp alltraps
80105e23:	e9 a6 f8 ff ff       	jmp    801056ce <alltraps>

80105e28 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $73
80105e2a:	6a 49                	push   $0x49
  jmp alltraps
80105e2c:	e9 9d f8 ff ff       	jmp    801056ce <alltraps>

80105e31 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $74
80105e33:	6a 4a                	push   $0x4a
  jmp alltraps
80105e35:	e9 94 f8 ff ff       	jmp    801056ce <alltraps>

80105e3a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $75
80105e3c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e3e:	e9 8b f8 ff ff       	jmp    801056ce <alltraps>

80105e43 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $76
80105e45:	6a 4c                	push   $0x4c
  jmp alltraps
80105e47:	e9 82 f8 ff ff       	jmp    801056ce <alltraps>

80105e4c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $77
80105e4e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e50:	e9 79 f8 ff ff       	jmp    801056ce <alltraps>

80105e55 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $78
80105e57:	6a 4e                	push   $0x4e
  jmp alltraps
80105e59:	e9 70 f8 ff ff       	jmp    801056ce <alltraps>

80105e5e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $79
80105e60:	6a 4f                	push   $0x4f
  jmp alltraps
80105e62:	e9 67 f8 ff ff       	jmp    801056ce <alltraps>

80105e67 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $80
80105e69:	6a 50                	push   $0x50
  jmp alltraps
80105e6b:	e9 5e f8 ff ff       	jmp    801056ce <alltraps>

80105e70 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $81
80105e72:	6a 51                	push   $0x51
  jmp alltraps
80105e74:	e9 55 f8 ff ff       	jmp    801056ce <alltraps>

80105e79 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $82
80105e7b:	6a 52                	push   $0x52
  jmp alltraps
80105e7d:	e9 4c f8 ff ff       	jmp    801056ce <alltraps>

80105e82 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $83
80105e84:	6a 53                	push   $0x53
  jmp alltraps
80105e86:	e9 43 f8 ff ff       	jmp    801056ce <alltraps>

80105e8b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $84
80105e8d:	6a 54                	push   $0x54
  jmp alltraps
80105e8f:	e9 3a f8 ff ff       	jmp    801056ce <alltraps>

80105e94 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $85
80105e96:	6a 55                	push   $0x55
  jmp alltraps
80105e98:	e9 31 f8 ff ff       	jmp    801056ce <alltraps>

80105e9d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $86
80105e9f:	6a 56                	push   $0x56
  jmp alltraps
80105ea1:	e9 28 f8 ff ff       	jmp    801056ce <alltraps>

80105ea6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $87
80105ea8:	6a 57                	push   $0x57
  jmp alltraps
80105eaa:	e9 1f f8 ff ff       	jmp    801056ce <alltraps>

80105eaf <vector88>:
.globl vector88
vector88:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $88
80105eb1:	6a 58                	push   $0x58
  jmp alltraps
80105eb3:	e9 16 f8 ff ff       	jmp    801056ce <alltraps>

80105eb8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $89
80105eba:	6a 59                	push   $0x59
  jmp alltraps
80105ebc:	e9 0d f8 ff ff       	jmp    801056ce <alltraps>

80105ec1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $90
80105ec3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ec5:	e9 04 f8 ff ff       	jmp    801056ce <alltraps>

80105eca <vector91>:
.globl vector91
vector91:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $91
80105ecc:	6a 5b                	push   $0x5b
  jmp alltraps
80105ece:	e9 fb f7 ff ff       	jmp    801056ce <alltraps>

80105ed3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $92
80105ed5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ed7:	e9 f2 f7 ff ff       	jmp    801056ce <alltraps>

80105edc <vector93>:
.globl vector93
vector93:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $93
80105ede:	6a 5d                	push   $0x5d
  jmp alltraps
80105ee0:	e9 e9 f7 ff ff       	jmp    801056ce <alltraps>

80105ee5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $94
80105ee7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ee9:	e9 e0 f7 ff ff       	jmp    801056ce <alltraps>

80105eee <vector95>:
.globl vector95
vector95:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $95
80105ef0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ef2:	e9 d7 f7 ff ff       	jmp    801056ce <alltraps>

80105ef7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $96
80105ef9:	6a 60                	push   $0x60
  jmp alltraps
80105efb:	e9 ce f7 ff ff       	jmp    801056ce <alltraps>

80105f00 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $97
80105f02:	6a 61                	push   $0x61
  jmp alltraps
80105f04:	e9 c5 f7 ff ff       	jmp    801056ce <alltraps>

80105f09 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $98
80105f0b:	6a 62                	push   $0x62
  jmp alltraps
80105f0d:	e9 bc f7 ff ff       	jmp    801056ce <alltraps>

80105f12 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $99
80105f14:	6a 63                	push   $0x63
  jmp alltraps
80105f16:	e9 b3 f7 ff ff       	jmp    801056ce <alltraps>

80105f1b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $100
80105f1d:	6a 64                	push   $0x64
  jmp alltraps
80105f1f:	e9 aa f7 ff ff       	jmp    801056ce <alltraps>

80105f24 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $101
80105f26:	6a 65                	push   $0x65
  jmp alltraps
80105f28:	e9 a1 f7 ff ff       	jmp    801056ce <alltraps>

80105f2d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $102
80105f2f:	6a 66                	push   $0x66
  jmp alltraps
80105f31:	e9 98 f7 ff ff       	jmp    801056ce <alltraps>

80105f36 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $103
80105f38:	6a 67                	push   $0x67
  jmp alltraps
80105f3a:	e9 8f f7 ff ff       	jmp    801056ce <alltraps>

80105f3f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $104
80105f41:	6a 68                	push   $0x68
  jmp alltraps
80105f43:	e9 86 f7 ff ff       	jmp    801056ce <alltraps>

80105f48 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $105
80105f4a:	6a 69                	push   $0x69
  jmp alltraps
80105f4c:	e9 7d f7 ff ff       	jmp    801056ce <alltraps>

80105f51 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $106
80105f53:	6a 6a                	push   $0x6a
  jmp alltraps
80105f55:	e9 74 f7 ff ff       	jmp    801056ce <alltraps>

80105f5a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $107
80105f5c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f5e:	e9 6b f7 ff ff       	jmp    801056ce <alltraps>

80105f63 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $108
80105f65:	6a 6c                	push   $0x6c
  jmp alltraps
80105f67:	e9 62 f7 ff ff       	jmp    801056ce <alltraps>

80105f6c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $109
80105f6e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f70:	e9 59 f7 ff ff       	jmp    801056ce <alltraps>

80105f75 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $110
80105f77:	6a 6e                	push   $0x6e
  jmp alltraps
80105f79:	e9 50 f7 ff ff       	jmp    801056ce <alltraps>

80105f7e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $111
80105f80:	6a 6f                	push   $0x6f
  jmp alltraps
80105f82:	e9 47 f7 ff ff       	jmp    801056ce <alltraps>

80105f87 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $112
80105f89:	6a 70                	push   $0x70
  jmp alltraps
80105f8b:	e9 3e f7 ff ff       	jmp    801056ce <alltraps>

80105f90 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $113
80105f92:	6a 71                	push   $0x71
  jmp alltraps
80105f94:	e9 35 f7 ff ff       	jmp    801056ce <alltraps>

80105f99 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $114
80105f9b:	6a 72                	push   $0x72
  jmp alltraps
80105f9d:	e9 2c f7 ff ff       	jmp    801056ce <alltraps>

80105fa2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $115
80105fa4:	6a 73                	push   $0x73
  jmp alltraps
80105fa6:	e9 23 f7 ff ff       	jmp    801056ce <alltraps>

80105fab <vector116>:
.globl vector116
vector116:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $116
80105fad:	6a 74                	push   $0x74
  jmp alltraps
80105faf:	e9 1a f7 ff ff       	jmp    801056ce <alltraps>

80105fb4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $117
80105fb6:	6a 75                	push   $0x75
  jmp alltraps
80105fb8:	e9 11 f7 ff ff       	jmp    801056ce <alltraps>

80105fbd <vector118>:
.globl vector118
vector118:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $118
80105fbf:	6a 76                	push   $0x76
  jmp alltraps
80105fc1:	e9 08 f7 ff ff       	jmp    801056ce <alltraps>

80105fc6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $119
80105fc8:	6a 77                	push   $0x77
  jmp alltraps
80105fca:	e9 ff f6 ff ff       	jmp    801056ce <alltraps>

80105fcf <vector120>:
.globl vector120
vector120:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $120
80105fd1:	6a 78                	push   $0x78
  jmp alltraps
80105fd3:	e9 f6 f6 ff ff       	jmp    801056ce <alltraps>

80105fd8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $121
80105fda:	6a 79                	push   $0x79
  jmp alltraps
80105fdc:	e9 ed f6 ff ff       	jmp    801056ce <alltraps>

80105fe1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $122
80105fe3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fe5:	e9 e4 f6 ff ff       	jmp    801056ce <alltraps>

80105fea <vector123>:
.globl vector123
vector123:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $123
80105fec:	6a 7b                	push   $0x7b
  jmp alltraps
80105fee:	e9 db f6 ff ff       	jmp    801056ce <alltraps>

80105ff3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $124
80105ff5:	6a 7c                	push   $0x7c
  jmp alltraps
80105ff7:	e9 d2 f6 ff ff       	jmp    801056ce <alltraps>

80105ffc <vector125>:
.globl vector125
vector125:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $125
80105ffe:	6a 7d                	push   $0x7d
  jmp alltraps
80106000:	e9 c9 f6 ff ff       	jmp    801056ce <alltraps>

80106005 <vector126>:
.globl vector126
vector126:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $126
80106007:	6a 7e                	push   $0x7e
  jmp alltraps
80106009:	e9 c0 f6 ff ff       	jmp    801056ce <alltraps>

8010600e <vector127>:
.globl vector127
vector127:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $127
80106010:	6a 7f                	push   $0x7f
  jmp alltraps
80106012:	e9 b7 f6 ff ff       	jmp    801056ce <alltraps>

80106017 <vector128>:
.globl vector128
vector128:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $128
80106019:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010601e:	e9 ab f6 ff ff       	jmp    801056ce <alltraps>

80106023 <vector129>:
.globl vector129
vector129:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $129
80106025:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010602a:	e9 9f f6 ff ff       	jmp    801056ce <alltraps>

8010602f <vector130>:
.globl vector130
vector130:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $130
80106031:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106036:	e9 93 f6 ff ff       	jmp    801056ce <alltraps>

8010603b <vector131>:
.globl vector131
vector131:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $131
8010603d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106042:	e9 87 f6 ff ff       	jmp    801056ce <alltraps>

80106047 <vector132>:
.globl vector132
vector132:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $132
80106049:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010604e:	e9 7b f6 ff ff       	jmp    801056ce <alltraps>

80106053 <vector133>:
.globl vector133
vector133:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $133
80106055:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010605a:	e9 6f f6 ff ff       	jmp    801056ce <alltraps>

8010605f <vector134>:
.globl vector134
vector134:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $134
80106061:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106066:	e9 63 f6 ff ff       	jmp    801056ce <alltraps>

8010606b <vector135>:
.globl vector135
vector135:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $135
8010606d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106072:	e9 57 f6 ff ff       	jmp    801056ce <alltraps>

80106077 <vector136>:
.globl vector136
vector136:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $136
80106079:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010607e:	e9 4b f6 ff ff       	jmp    801056ce <alltraps>

80106083 <vector137>:
.globl vector137
vector137:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $137
80106085:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010608a:	e9 3f f6 ff ff       	jmp    801056ce <alltraps>

8010608f <vector138>:
.globl vector138
vector138:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $138
80106091:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106096:	e9 33 f6 ff ff       	jmp    801056ce <alltraps>

8010609b <vector139>:
.globl vector139
vector139:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $139
8010609d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060a2:	e9 27 f6 ff ff       	jmp    801056ce <alltraps>

801060a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $140
801060a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060ae:	e9 1b f6 ff ff       	jmp    801056ce <alltraps>

801060b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $141
801060b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060ba:	e9 0f f6 ff ff       	jmp    801056ce <alltraps>

801060bf <vector142>:
.globl vector142
vector142:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $142
801060c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060c6:	e9 03 f6 ff ff       	jmp    801056ce <alltraps>

801060cb <vector143>:
.globl vector143
vector143:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $143
801060cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060d2:	e9 f7 f5 ff ff       	jmp    801056ce <alltraps>

801060d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $144
801060d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060de:	e9 eb f5 ff ff       	jmp    801056ce <alltraps>

801060e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $145
801060e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060ea:	e9 df f5 ff ff       	jmp    801056ce <alltraps>

801060ef <vector146>:
.globl vector146
vector146:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $146
801060f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060f6:	e9 d3 f5 ff ff       	jmp    801056ce <alltraps>

801060fb <vector147>:
.globl vector147
vector147:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $147
801060fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106102:	e9 c7 f5 ff ff       	jmp    801056ce <alltraps>

80106107 <vector148>:
.globl vector148
vector148:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $148
80106109:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010610e:	e9 bb f5 ff ff       	jmp    801056ce <alltraps>

80106113 <vector149>:
.globl vector149
vector149:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $149
80106115:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010611a:	e9 af f5 ff ff       	jmp    801056ce <alltraps>

8010611f <vector150>:
.globl vector150
vector150:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $150
80106121:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106126:	e9 a3 f5 ff ff       	jmp    801056ce <alltraps>

8010612b <vector151>:
.globl vector151
vector151:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $151
8010612d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106132:	e9 97 f5 ff ff       	jmp    801056ce <alltraps>

80106137 <vector152>:
.globl vector152
vector152:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $152
80106139:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010613e:	e9 8b f5 ff ff       	jmp    801056ce <alltraps>

80106143 <vector153>:
.globl vector153
vector153:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $153
80106145:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010614a:	e9 7f f5 ff ff       	jmp    801056ce <alltraps>

8010614f <vector154>:
.globl vector154
vector154:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $154
80106151:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106156:	e9 73 f5 ff ff       	jmp    801056ce <alltraps>

8010615b <vector155>:
.globl vector155
vector155:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $155
8010615d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106162:	e9 67 f5 ff ff       	jmp    801056ce <alltraps>

80106167 <vector156>:
.globl vector156
vector156:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $156
80106169:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010616e:	e9 5b f5 ff ff       	jmp    801056ce <alltraps>

80106173 <vector157>:
.globl vector157
vector157:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $157
80106175:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010617a:	e9 4f f5 ff ff       	jmp    801056ce <alltraps>

8010617f <vector158>:
.globl vector158
vector158:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $158
80106181:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106186:	e9 43 f5 ff ff       	jmp    801056ce <alltraps>

8010618b <vector159>:
.globl vector159
vector159:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $159
8010618d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106192:	e9 37 f5 ff ff       	jmp    801056ce <alltraps>

80106197 <vector160>:
.globl vector160
vector160:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $160
80106199:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010619e:	e9 2b f5 ff ff       	jmp    801056ce <alltraps>

801061a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $161
801061a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061aa:	e9 1f f5 ff ff       	jmp    801056ce <alltraps>

801061af <vector162>:
.globl vector162
vector162:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $162
801061b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061b6:	e9 13 f5 ff ff       	jmp    801056ce <alltraps>

801061bb <vector163>:
.globl vector163
vector163:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $163
801061bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061c2:	e9 07 f5 ff ff       	jmp    801056ce <alltraps>

801061c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $164
801061c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061ce:	e9 fb f4 ff ff       	jmp    801056ce <alltraps>

801061d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $165
801061d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061da:	e9 ef f4 ff ff       	jmp    801056ce <alltraps>

801061df <vector166>:
.globl vector166
vector166:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $166
801061e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061e6:	e9 e3 f4 ff ff       	jmp    801056ce <alltraps>

801061eb <vector167>:
.globl vector167
vector167:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $167
801061ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061f2:	e9 d7 f4 ff ff       	jmp    801056ce <alltraps>

801061f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $168
801061f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061fe:	e9 cb f4 ff ff       	jmp    801056ce <alltraps>

80106203 <vector169>:
.globl vector169
vector169:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $169
80106205:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010620a:	e9 bf f4 ff ff       	jmp    801056ce <alltraps>

8010620f <vector170>:
.globl vector170
vector170:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $170
80106211:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106216:	e9 b3 f4 ff ff       	jmp    801056ce <alltraps>

8010621b <vector171>:
.globl vector171
vector171:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $171
8010621d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106222:	e9 a7 f4 ff ff       	jmp    801056ce <alltraps>

80106227 <vector172>:
.globl vector172
vector172:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $172
80106229:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010622e:	e9 9b f4 ff ff       	jmp    801056ce <alltraps>

80106233 <vector173>:
.globl vector173
vector173:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $173
80106235:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010623a:	e9 8f f4 ff ff       	jmp    801056ce <alltraps>

8010623f <vector174>:
.globl vector174
vector174:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $174
80106241:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106246:	e9 83 f4 ff ff       	jmp    801056ce <alltraps>

8010624b <vector175>:
.globl vector175
vector175:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $175
8010624d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106252:	e9 77 f4 ff ff       	jmp    801056ce <alltraps>

80106257 <vector176>:
.globl vector176
vector176:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $176
80106259:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010625e:	e9 6b f4 ff ff       	jmp    801056ce <alltraps>

80106263 <vector177>:
.globl vector177
vector177:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $177
80106265:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010626a:	e9 5f f4 ff ff       	jmp    801056ce <alltraps>

8010626f <vector178>:
.globl vector178
vector178:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $178
80106271:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106276:	e9 53 f4 ff ff       	jmp    801056ce <alltraps>

8010627b <vector179>:
.globl vector179
vector179:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $179
8010627d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106282:	e9 47 f4 ff ff       	jmp    801056ce <alltraps>

80106287 <vector180>:
.globl vector180
vector180:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $180
80106289:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010628e:	e9 3b f4 ff ff       	jmp    801056ce <alltraps>

80106293 <vector181>:
.globl vector181
vector181:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $181
80106295:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010629a:	e9 2f f4 ff ff       	jmp    801056ce <alltraps>

8010629f <vector182>:
.globl vector182
vector182:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $182
801062a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062a6:	e9 23 f4 ff ff       	jmp    801056ce <alltraps>

801062ab <vector183>:
.globl vector183
vector183:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $183
801062ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062b2:	e9 17 f4 ff ff       	jmp    801056ce <alltraps>

801062b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $184
801062b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062be:	e9 0b f4 ff ff       	jmp    801056ce <alltraps>

801062c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $185
801062c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062ca:	e9 ff f3 ff ff       	jmp    801056ce <alltraps>

801062cf <vector186>:
.globl vector186
vector186:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $186
801062d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062d6:	e9 f3 f3 ff ff       	jmp    801056ce <alltraps>

801062db <vector187>:
.globl vector187
vector187:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $187
801062dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062e2:	e9 e7 f3 ff ff       	jmp    801056ce <alltraps>

801062e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $188
801062e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062ee:	e9 db f3 ff ff       	jmp    801056ce <alltraps>

801062f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $189
801062f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062fa:	e9 cf f3 ff ff       	jmp    801056ce <alltraps>

801062ff <vector190>:
.globl vector190
vector190:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $190
80106301:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106306:	e9 c3 f3 ff ff       	jmp    801056ce <alltraps>

8010630b <vector191>:
.globl vector191
vector191:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $191
8010630d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106312:	e9 b7 f3 ff ff       	jmp    801056ce <alltraps>

80106317 <vector192>:
.globl vector192
vector192:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $192
80106319:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010631e:	e9 ab f3 ff ff       	jmp    801056ce <alltraps>

80106323 <vector193>:
.globl vector193
vector193:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $193
80106325:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010632a:	e9 9f f3 ff ff       	jmp    801056ce <alltraps>

8010632f <vector194>:
.globl vector194
vector194:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $194
80106331:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106336:	e9 93 f3 ff ff       	jmp    801056ce <alltraps>

8010633b <vector195>:
.globl vector195
vector195:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $195
8010633d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106342:	e9 87 f3 ff ff       	jmp    801056ce <alltraps>

80106347 <vector196>:
.globl vector196
vector196:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $196
80106349:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010634e:	e9 7b f3 ff ff       	jmp    801056ce <alltraps>

80106353 <vector197>:
.globl vector197
vector197:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $197
80106355:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010635a:	e9 6f f3 ff ff       	jmp    801056ce <alltraps>

8010635f <vector198>:
.globl vector198
vector198:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $198
80106361:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106366:	e9 63 f3 ff ff       	jmp    801056ce <alltraps>

8010636b <vector199>:
.globl vector199
vector199:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $199
8010636d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106372:	e9 57 f3 ff ff       	jmp    801056ce <alltraps>

80106377 <vector200>:
.globl vector200
vector200:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $200
80106379:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010637e:	e9 4b f3 ff ff       	jmp    801056ce <alltraps>

80106383 <vector201>:
.globl vector201
vector201:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $201
80106385:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010638a:	e9 3f f3 ff ff       	jmp    801056ce <alltraps>

8010638f <vector202>:
.globl vector202
vector202:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $202
80106391:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106396:	e9 33 f3 ff ff       	jmp    801056ce <alltraps>

8010639b <vector203>:
.globl vector203
vector203:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $203
8010639d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063a2:	e9 27 f3 ff ff       	jmp    801056ce <alltraps>

801063a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $204
801063a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063ae:	e9 1b f3 ff ff       	jmp    801056ce <alltraps>

801063b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $205
801063b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063ba:	e9 0f f3 ff ff       	jmp    801056ce <alltraps>

801063bf <vector206>:
.globl vector206
vector206:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $206
801063c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063c6:	e9 03 f3 ff ff       	jmp    801056ce <alltraps>

801063cb <vector207>:
.globl vector207
vector207:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $207
801063cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063d2:	e9 f7 f2 ff ff       	jmp    801056ce <alltraps>

801063d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $208
801063d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063de:	e9 eb f2 ff ff       	jmp    801056ce <alltraps>

801063e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $209
801063e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063ea:	e9 df f2 ff ff       	jmp    801056ce <alltraps>

801063ef <vector210>:
.globl vector210
vector210:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $210
801063f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063f6:	e9 d3 f2 ff ff       	jmp    801056ce <alltraps>

801063fb <vector211>:
.globl vector211
vector211:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $211
801063fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106402:	e9 c7 f2 ff ff       	jmp    801056ce <alltraps>

80106407 <vector212>:
.globl vector212
vector212:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $212
80106409:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010640e:	e9 bb f2 ff ff       	jmp    801056ce <alltraps>

80106413 <vector213>:
.globl vector213
vector213:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $213
80106415:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010641a:	e9 af f2 ff ff       	jmp    801056ce <alltraps>

8010641f <vector214>:
.globl vector214
vector214:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $214
80106421:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106426:	e9 a3 f2 ff ff       	jmp    801056ce <alltraps>

8010642b <vector215>:
.globl vector215
vector215:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $215
8010642d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106432:	e9 97 f2 ff ff       	jmp    801056ce <alltraps>

80106437 <vector216>:
.globl vector216
vector216:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $216
80106439:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010643e:	e9 8b f2 ff ff       	jmp    801056ce <alltraps>

80106443 <vector217>:
.globl vector217
vector217:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $217
80106445:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010644a:	e9 7f f2 ff ff       	jmp    801056ce <alltraps>

8010644f <vector218>:
.globl vector218
vector218:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $218
80106451:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106456:	e9 73 f2 ff ff       	jmp    801056ce <alltraps>

8010645b <vector219>:
.globl vector219
vector219:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $219
8010645d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106462:	e9 67 f2 ff ff       	jmp    801056ce <alltraps>

80106467 <vector220>:
.globl vector220
vector220:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $220
80106469:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010646e:	e9 5b f2 ff ff       	jmp    801056ce <alltraps>

80106473 <vector221>:
.globl vector221
vector221:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $221
80106475:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010647a:	e9 4f f2 ff ff       	jmp    801056ce <alltraps>

8010647f <vector222>:
.globl vector222
vector222:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $222
80106481:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106486:	e9 43 f2 ff ff       	jmp    801056ce <alltraps>

8010648b <vector223>:
.globl vector223
vector223:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $223
8010648d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106492:	e9 37 f2 ff ff       	jmp    801056ce <alltraps>

80106497 <vector224>:
.globl vector224
vector224:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $224
80106499:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010649e:	e9 2b f2 ff ff       	jmp    801056ce <alltraps>

801064a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $225
801064a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064aa:	e9 1f f2 ff ff       	jmp    801056ce <alltraps>

801064af <vector226>:
.globl vector226
vector226:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $226
801064b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064b6:	e9 13 f2 ff ff       	jmp    801056ce <alltraps>

801064bb <vector227>:
.globl vector227
vector227:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $227
801064bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064c2:	e9 07 f2 ff ff       	jmp    801056ce <alltraps>

801064c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $228
801064c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064ce:	e9 fb f1 ff ff       	jmp    801056ce <alltraps>

801064d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $229
801064d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064da:	e9 ef f1 ff ff       	jmp    801056ce <alltraps>

801064df <vector230>:
.globl vector230
vector230:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $230
801064e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064e6:	e9 e3 f1 ff ff       	jmp    801056ce <alltraps>

801064eb <vector231>:
.globl vector231
vector231:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $231
801064ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064f2:	e9 d7 f1 ff ff       	jmp    801056ce <alltraps>

801064f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $232
801064f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064fe:	e9 cb f1 ff ff       	jmp    801056ce <alltraps>

80106503 <vector233>:
.globl vector233
vector233:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $233
80106505:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010650a:	e9 bf f1 ff ff       	jmp    801056ce <alltraps>

8010650f <vector234>:
.globl vector234
vector234:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $234
80106511:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106516:	e9 b3 f1 ff ff       	jmp    801056ce <alltraps>

8010651b <vector235>:
.globl vector235
vector235:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $235
8010651d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106522:	e9 a7 f1 ff ff       	jmp    801056ce <alltraps>

80106527 <vector236>:
.globl vector236
vector236:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $236
80106529:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010652e:	e9 9b f1 ff ff       	jmp    801056ce <alltraps>

80106533 <vector237>:
.globl vector237
vector237:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $237
80106535:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010653a:	e9 8f f1 ff ff       	jmp    801056ce <alltraps>

8010653f <vector238>:
.globl vector238
vector238:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $238
80106541:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106546:	e9 83 f1 ff ff       	jmp    801056ce <alltraps>

8010654b <vector239>:
.globl vector239
vector239:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $239
8010654d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106552:	e9 77 f1 ff ff       	jmp    801056ce <alltraps>

80106557 <vector240>:
.globl vector240
vector240:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $240
80106559:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010655e:	e9 6b f1 ff ff       	jmp    801056ce <alltraps>

80106563 <vector241>:
.globl vector241
vector241:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $241
80106565:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010656a:	e9 5f f1 ff ff       	jmp    801056ce <alltraps>

8010656f <vector242>:
.globl vector242
vector242:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $242
80106571:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106576:	e9 53 f1 ff ff       	jmp    801056ce <alltraps>

8010657b <vector243>:
.globl vector243
vector243:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $243
8010657d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106582:	e9 47 f1 ff ff       	jmp    801056ce <alltraps>

80106587 <vector244>:
.globl vector244
vector244:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $244
80106589:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010658e:	e9 3b f1 ff ff       	jmp    801056ce <alltraps>

80106593 <vector245>:
.globl vector245
vector245:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $245
80106595:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010659a:	e9 2f f1 ff ff       	jmp    801056ce <alltraps>

8010659f <vector246>:
.globl vector246
vector246:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $246
801065a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065a6:	e9 23 f1 ff ff       	jmp    801056ce <alltraps>

801065ab <vector247>:
.globl vector247
vector247:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $247
801065ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065b2:	e9 17 f1 ff ff       	jmp    801056ce <alltraps>

801065b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $248
801065b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065be:	e9 0b f1 ff ff       	jmp    801056ce <alltraps>

801065c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $249
801065c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065ca:	e9 ff f0 ff ff       	jmp    801056ce <alltraps>

801065cf <vector250>:
.globl vector250
vector250:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $250
801065d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065d6:	e9 f3 f0 ff ff       	jmp    801056ce <alltraps>

801065db <vector251>:
.globl vector251
vector251:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $251
801065dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065e2:	e9 e7 f0 ff ff       	jmp    801056ce <alltraps>

801065e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $252
801065e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065ee:	e9 db f0 ff ff       	jmp    801056ce <alltraps>

801065f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $253
801065f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065fa:	e9 cf f0 ff ff       	jmp    801056ce <alltraps>

801065ff <vector254>:
.globl vector254
vector254:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $254
80106601:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106606:	e9 c3 f0 ff ff       	jmp    801056ce <alltraps>

8010660b <vector255>:
.globl vector255
vector255:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $255
8010660d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106612:	e9 b7 f0 ff ff       	jmp    801056ce <alltraps>
80106617:	66 90                	xchg   %ax,%ax
80106619:	66 90                	xchg   %ax,%ax
8010661b:	66 90                	xchg   %ax,%ax
8010661d:	66 90                	xchg   %ax,%ax
8010661f:	90                   	nop

80106620 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	57                   	push   %edi
80106624:	56                   	push   %esi
80106625:	53                   	push   %ebx
80106626:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106628:	c1 ea 16             	shr    $0x16,%edx
8010662b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010662e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106631:	8b 07                	mov    (%edi),%eax
80106633:	a8 01                	test   $0x1,%al
80106635:	74 29                	je     80106660 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106637:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010663c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106642:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106645:	c1 eb 0a             	shr    $0xa,%ebx
80106648:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010664e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106651:	5b                   	pop    %ebx
80106652:	5e                   	pop    %esi
80106653:	5f                   	pop    %edi
80106654:	5d                   	pop    %ebp
80106655:	c3                   	ret    
80106656:	8d 76 00             	lea    0x0(%esi),%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106660:	85 c9                	test   %ecx,%ecx
80106662:	74 2c                	je     80106690 <walkpgdir+0x70>
80106664:	e8 37 be ff ff       	call   801024a0 <kalloc>
80106669:	85 c0                	test   %eax,%eax
8010666b:	89 c6                	mov    %eax,%esi
8010666d:	74 21                	je     80106690 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010666f:	83 ec 04             	sub    $0x4,%esp
80106672:	68 00 10 00 00       	push   $0x1000
80106677:	6a 00                	push   $0x0
80106679:	50                   	push   %eax
8010667a:	e8 31 de ff ff       	call   801044b0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010667f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106685:	83 c4 10             	add    $0x10,%esp
80106688:	83 c8 07             	or     $0x7,%eax
8010668b:	89 07                	mov    %eax,(%edi)
8010668d:	eb b3                	jmp    80106642 <walkpgdir+0x22>
8010668f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106693:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106695:	5b                   	pop    %ebx
80106696:	5e                   	pop    %esi
80106697:	5f                   	pop    %edi
80106698:	5d                   	pop    %ebp
80106699:	c3                   	ret    
8010669a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	57                   	push   %edi
801066a4:	56                   	push   %esi
801066a5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066a6:	89 d3                	mov    %edx,%ebx
801066a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066ae:	83 ec 1c             	sub    $0x1c,%esp
801066b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801066b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801066bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801066c6:	29 df                	sub    %ebx,%edi
801066c8:	83 c8 01             	or     $0x1,%eax
801066cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066ce:	eb 15                	jmp    801066e5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801066d0:	f6 00 01             	testb  $0x1,(%eax)
801066d3:	75 45                	jne    8010671a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801066d5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801066d8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801066dd:	74 31                	je     80106710 <mappages+0x70>
      break;
    a += PGSIZE;
801066df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801066ed:	89 da                	mov    %ebx,%edx
801066ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801066f2:	e8 29 ff ff ff       	call   80106620 <walkpgdir>
801066f7:	85 c0                	test   %eax,%eax
801066f9:	75 d5                	jne    801066d0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801066fb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801066fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106703:	5b                   	pop    %ebx
80106704:	5e                   	pop    %esi
80106705:	5f                   	pop    %edi
80106706:	5d                   	pop    %ebp
80106707:	c3                   	ret    
80106708:	90                   	nop
80106709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106710:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106713:	31 c0                	xor    %eax,%eax
}
80106715:	5b                   	pop    %ebx
80106716:	5e                   	pop    %esi
80106717:	5f                   	pop    %edi
80106718:	5d                   	pop    %ebp
80106719:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010671a:	83 ec 0c             	sub    $0xc,%esp
8010671d:	68 28 78 10 80       	push   $0x80107828
80106722:	e8 49 9c ff ff       	call   80100370 <panic>
80106727:	89 f6                	mov    %esi,%esi
80106729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106730 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106736:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010673c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010673e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106744:	83 ec 1c             	sub    $0x1c,%esp
80106747:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010674a:	39 d3                	cmp    %edx,%ebx
8010674c:	73 66                	jae    801067b4 <deallocuvm.part.0+0x84>
8010674e:	89 d6                	mov    %edx,%esi
80106750:	eb 3d                	jmp    8010678f <deallocuvm.part.0+0x5f>
80106752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106758:	8b 10                	mov    (%eax),%edx
8010675a:	f6 c2 01             	test   $0x1,%dl
8010675d:	74 26                	je     80106785 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010675f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106765:	74 58                	je     801067bf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106767:	83 ec 0c             	sub    $0xc,%esp
8010676a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106773:	52                   	push   %edx
80106774:	e8 77 bb ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010677c:	83 c4 10             	add    $0x10,%esp
8010677f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106785:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010678b:	39 f3                	cmp    %esi,%ebx
8010678d:	73 25                	jae    801067b4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010678f:	31 c9                	xor    %ecx,%ecx
80106791:	89 da                	mov    %ebx,%edx
80106793:	89 f8                	mov    %edi,%eax
80106795:	e8 86 fe ff ff       	call   80106620 <walkpgdir>
    if(!pte)
8010679a:	85 c0                	test   %eax,%eax
8010679c:	75 ba                	jne    80106758 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010679e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801067a4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067b0:	39 f3                	cmp    %esi,%ebx
801067b2:	72 db                	jb     8010678f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ba:	5b                   	pop    %ebx
801067bb:	5e                   	pop    %esi
801067bc:	5f                   	pop    %edi
801067bd:	5d                   	pop    %ebp
801067be:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067bf:	83 ec 0c             	sub    $0xc,%esp
801067c2:	68 f2 71 10 80       	push   $0x801071f2
801067c7:	e8 a4 9b ff ff       	call   80100370 <panic>
801067cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067d0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067d4:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801067d6:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801067d9:	e8 22 bf ff ff       	call   80102700 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067de:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801067e4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
801067e9:	8d 90 a0 27 11 80    	lea    -0x7feed860(%eax),%edx
801067ef:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
801067f6:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067fd:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
80106804:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010680b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010680f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106814:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106818:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
8010681f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106821:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106826:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010682d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106834:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106836:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010683b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106842:	31 db                	xor    %ebx,%ebx
80106844:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010684b:	8d 88 54 28 11 80    	lea    -0x7feed7ac(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106851:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106858:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010685a:	c6 80 35 28 11 80 fa 	movb   $0xfa,-0x7feed7cb(%eax)
80106861:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106868:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
8010686f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106876:	89 cb                	mov    %ecx,%ebx
80106878:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010687b:	c6 80 3d 28 11 80 f2 	movb   $0xf2,-0x7feed7c3(%eax)
80106882:	c6 80 3e 28 11 80 cf 	movb   $0xcf,-0x7feed7c2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106889:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
8010688f:	c6 80 2d 28 11 80 92 	movb   $0x92,-0x7feed7d3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106896:	b9 37 00 00 00       	mov    $0x37,%ecx
8010689b:	c6 80 2e 28 11 80 c0 	movb   $0xc0,-0x7feed7d2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801068a2:	05 10 28 11 80       	add    $0x80112810,%eax
801068a7:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068ab:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
801068ae:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068b2:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068b5:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
801068b9:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068bd:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
801068c4:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068cb:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
801068d2:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068d9:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
801068e0:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068e7:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
801068ed:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801068f1:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068f4:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
801068f7:	b8 18 00 00 00       	mov    $0x18,%eax
801068fc:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
801068fe:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106905:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106909:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106910:	83 c4 14             	add    $0x14,%esp
80106913:	5b                   	pop    %ebx
80106914:	5d                   	pop    %ebp
80106915:	c3                   	ret    
80106916:	8d 76 00             	lea    0x0(%esi),%esi
80106919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106920 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	56                   	push   %esi
80106924:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106925:	e8 76 bb ff ff       	call   801024a0 <kalloc>
8010692a:	85 c0                	test   %eax,%eax
8010692c:	74 52                	je     80106980 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010692e:	83 ec 04             	sub    $0x4,%esp
80106931:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106933:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106938:	68 00 10 00 00       	push   $0x1000
8010693d:	6a 00                	push   $0x0
8010693f:	50                   	push   %eax
80106940:	e8 6b db ff ff       	call   801044b0 <memset>
80106945:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106948:	8b 43 04             	mov    0x4(%ebx),%eax
8010694b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010694e:	83 ec 08             	sub    $0x8,%esp
80106951:	8b 13                	mov    (%ebx),%edx
80106953:	ff 73 0c             	pushl  0xc(%ebx)
80106956:	50                   	push   %eax
80106957:	29 c1                	sub    %eax,%ecx
80106959:	89 f0                	mov    %esi,%eax
8010695b:	e8 40 fd ff ff       	call   801066a0 <mappages>
80106960:	83 c4 10             	add    $0x10,%esp
80106963:	85 c0                	test   %eax,%eax
80106965:	78 19                	js     80106980 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106967:	83 c3 10             	add    $0x10,%ebx
8010696a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106970:	75 d6                	jne    80106948 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106972:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106975:	89 f0                	mov    %esi,%eax
80106977:	5b                   	pop    %ebx
80106978:	5e                   	pop    %esi
80106979:	5d                   	pop    %ebp
8010697a:	c3                   	ret    
8010697b:	90                   	nop
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106980:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106983:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5d                   	pop    %ebp
80106988:	c3                   	ret    
80106989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106990 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106996:	e8 85 ff ff ff       	call   80106920 <setupkvm>
8010699b:	a3 24 55 11 80       	mov    %eax,0x80115524
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069a0:	05 00 00 00 80       	add    $0x80000000,%eax
801069a5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801069a8:	c9                   	leave  
801069a9:	c3                   	ret    
801069aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069b0 <switchkvm>:
801069b0:	a1 24 55 11 80       	mov    0x80115524,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069b5:	55                   	push   %ebp
801069b6:	89 e5                	mov    %esp,%ebp
801069b8:	05 00 00 00 80       	add    $0x80000000,%eax
801069bd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801069c0:	5d                   	pop    %ebp
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	53                   	push   %ebx
801069d4:	83 ec 04             	sub    $0x4,%esp
801069d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801069da:	85 db                	test   %ebx,%ebx
801069dc:	0f 84 93 00 00 00    	je     80106a75 <switchuvm+0xa5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801069e2:	8b 43 08             	mov    0x8(%ebx),%eax
801069e5:	85 c0                	test   %eax,%eax
801069e7:	0f 84 a2 00 00 00    	je     80106a8f <switchuvm+0xbf>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801069ed:	8b 43 04             	mov    0x4(%ebx),%eax
801069f0:	85 c0                	test   %eax,%eax
801069f2:	0f 84 8a 00 00 00    	je     80106a82 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
801069f8:	e8 e3 d9 ff ff       	call   801043e0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801069fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a03:	b9 67 00 00 00       	mov    $0x67,%ecx
80106a08:	8d 50 08             	lea    0x8(%eax),%edx
80106a0b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106a12:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106a19:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a20:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106a27:	89 d1                	mov    %edx,%ecx
80106a29:	c1 ea 18             	shr    $0x18,%edx
80106a2c:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106a32:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106a35:	ba 10 00 00 00       	mov    $0x10,%edx
80106a3a:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a3e:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a44:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a47:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106a4d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106a52:	66 89 48 6e          	mov    %cx,0x6e(%eax)

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a56:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a59:	b8 30 00 00 00       	mov    $0x30,%eax
80106a5e:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a61:	8b 43 04             	mov    0x4(%ebx),%eax
80106a64:	05 00 00 00 80       	add    $0x80000000,%eax
80106a69:	0f 22 d8             	mov    %eax,%cr3
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a6f:	c9                   	leave  
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106a70:	e9 9b d9 ff ff       	jmp    80104410 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106a75:	83 ec 0c             	sub    $0xc,%esp
80106a78:	68 2e 78 10 80       	push   $0x8010782e
80106a7d:	e8 ee 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106a82:	83 ec 0c             	sub    $0xc,%esp
80106a85:	68 59 78 10 80       	push   $0x80107859
80106a8a:	e8 e1 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106a8f:	83 ec 0c             	sub    $0xc,%esp
80106a92:	68 44 78 10 80       	push   $0x80107844
80106a97:	e8 d4 98 ff ff       	call   80100370 <panic>
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 75 10             	mov    0x10(%ebp),%esi
80106aac:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ab2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106abb:	77 49                	ja     80106b06 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106abd:	e8 de b9 ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ac2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ac5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ac7:	68 00 10 00 00       	push   $0x1000
80106acc:	6a 00                	push   $0x0
80106ace:	50                   	push   %eax
80106acf:	e8 dc d9 ff ff       	call   801044b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ad4:	58                   	pop    %eax
80106ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106adb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ae0:	5a                   	pop    %edx
80106ae1:	6a 06                	push   $0x6
80106ae3:	50                   	push   %eax
80106ae4:	31 d2                	xor    %edx,%edx
80106ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae9:	e8 b2 fb ff ff       	call   801066a0 <mappages>
  memmove(mem, init, sz);
80106aee:	89 75 10             	mov    %esi,0x10(%ebp)
80106af1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106af4:	83 c4 10             	add    $0x10,%esp
80106af7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106afd:	5b                   	pop    %ebx
80106afe:	5e                   	pop    %esi
80106aff:	5f                   	pop    %edi
80106b00:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b01:	e9 5a da ff ff       	jmp    80104560 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	68 6d 78 10 80       	push   $0x8010786d
80106b0e:	e8 5d 98 ff ff       	call   80100370 <panic>
80106b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b30:	0f 85 91 00 00 00    	jne    80106bc7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b36:	8b 75 18             	mov    0x18(%ebp),%esi
80106b39:	31 db                	xor    %ebx,%ebx
80106b3b:	85 f6                	test   %esi,%esi
80106b3d:	75 1a                	jne    80106b59 <loaduvm+0x39>
80106b3f:	eb 6f                	jmp    80106bb0 <loaduvm+0x90>
80106b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b57:	76 57                	jbe    80106bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5f:	31 c9                	xor    %ecx,%ecx
80106b61:	01 da                	add    %ebx,%edx
80106b63:	e8 b8 fa ff ff       	call   80106620 <walkpgdir>
80106b68:	85 c0                	test   %eax,%eax
80106b6a:	74 4e                	je     80106bba <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b6c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106b71:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b81:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b84:	01 d9                	add    %ebx,%ecx
80106b86:	05 00 00 00 80       	add    $0x80000000,%eax
80106b8b:	57                   	push   %edi
80106b8c:	51                   	push   %ecx
80106b8d:	50                   	push   %eax
80106b8e:	ff 75 10             	pushl  0x10(%ebp)
80106b91:	e8 aa ad ff ff       	call   80101940 <readi>
80106b96:	83 c4 10             	add    $0x10,%esp
80106b99:	39 c7                	cmp    %eax,%edi
80106b9b:	74 ab                	je     80106b48 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 87 78 10 80       	push   $0x80107887
80106bc2:	e8 a9 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106bc7:	83 ec 0c             	sub    $0xc,%esp
80106bca:	68 28 79 10 80       	push   $0x80107928
80106bcf:	e8 9c 97 ff ff       	call   80100370 <panic>
80106bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106be0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 0c             	sub    $0xc,%esp
80106be9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106bec:	85 ff                	test   %edi,%edi
80106bee:	0f 88 ca 00 00 00    	js     80106cbe <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106bf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106bfa:	0f 82 82 00 00 00    	jb     80106c82 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c0c:	39 df                	cmp    %ebx,%edi
80106c0e:	77 43                	ja     80106c53 <allocuvm+0x73>
80106c10:	e9 bb 00 00 00       	jmp    80106cd0 <allocuvm+0xf0>
80106c15:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c18:	83 ec 04             	sub    $0x4,%esp
80106c1b:	68 00 10 00 00       	push   $0x1000
80106c20:	6a 00                	push   $0x0
80106c22:	50                   	push   %eax
80106c23:	e8 88 d8 ff ff       	call   801044b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c28:	58                   	pop    %eax
80106c29:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c2f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c34:	5a                   	pop    %edx
80106c35:	6a 06                	push   $0x6
80106c37:	50                   	push   %eax
80106c38:	89 da                	mov    %ebx,%edx
80106c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c3d:	e8 5e fa ff ff       	call   801066a0 <mappages>
80106c42:	83 c4 10             	add    $0x10,%esp
80106c45:	85 c0                	test   %eax,%eax
80106c47:	78 47                	js     80106c90 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c4f:	39 df                	cmp    %ebx,%edi
80106c51:	76 7d                	jbe    80106cd0 <allocuvm+0xf0>
    mem = kalloc();
80106c53:	e8 48 b8 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106c58:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c5a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c5c:	75 ba                	jne    80106c18 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c5e:	83 ec 0c             	sub    $0xc,%esp
80106c61:	68 a5 78 10 80       	push   $0x801078a5
80106c66:	e8 f5 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c6b:	83 c4 10             	add    $0x10,%esp
80106c6e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c71:	76 4b                	jbe    80106cbe <allocuvm+0xde>
80106c73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c76:	8b 45 08             	mov    0x8(%ebp),%eax
80106c79:	89 fa                	mov    %edi,%edx
80106c7b:	e8 b0 fa ff ff       	call   80106730 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c80:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c90:	83 ec 0c             	sub    $0xc,%esp
80106c93:	68 bd 78 10 80       	push   $0x801078bd
80106c98:	e8 c3 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c9d:	83 c4 10             	add    $0x10,%esp
80106ca0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ca3:	76 0d                	jbe    80106cb2 <allocuvm+0xd2>
80106ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80106cab:	89 fa                	mov    %edi,%edx
80106cad:	e8 7e fa ff ff       	call   80106730 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106cb2:	83 ec 0c             	sub    $0xc,%esp
80106cb5:	56                   	push   %esi
80106cb6:	e8 35 b6 ff ff       	call   801022f0 <kfree>
      return 0;
80106cbb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106cc1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106cc3:	5b                   	pop    %ebx
80106cc4:	5e                   	pop    %esi
80106cc5:	5f                   	pop    %edi
80106cc6:	5d                   	pop    %ebp
80106cc7:	c3                   	ret    
80106cc8:	90                   	nop
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106cd3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ce0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ce6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cec:	39 d1                	cmp    %edx,%ecx
80106cee:	73 10                	jae    80106d00 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cf0:	5d                   	pop    %ebp
80106cf1:	e9 3a fa ff ff       	jmp    80106730 <deallocuvm.part.0>
80106cf6:	8d 76 00             	lea    0x0(%esi),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d00:	89 d0                	mov    %edx,%eax
80106d02:	5d                   	pop    %ebp
80106d03:	c3                   	ret    
80106d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 0c             	sub    $0xc,%esp
80106d19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d1c:	85 f6                	test   %esi,%esi
80106d1e:	74 59                	je     80106d79 <freevm+0x69>
80106d20:	31 c9                	xor    %ecx,%ecx
80106d22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d27:	89 f0                	mov    %esi,%eax
80106d29:	e8 02 fa ff ff       	call   80106730 <deallocuvm.part.0>
80106d2e:	89 f3                	mov    %esi,%ebx
80106d30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d36:	eb 0f                	jmp    80106d47 <freevm+0x37>
80106d38:	90                   	nop
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d40:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d43:	39 fb                	cmp    %edi,%ebx
80106d45:	74 23                	je     80106d6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d47:	8b 03                	mov    (%ebx),%eax
80106d49:	a8 01                	test   $0x1,%al
80106d4b:	74 f3                	je     80106d40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106d4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d52:	83 ec 0c             	sub    $0xc,%esp
80106d55:	83 c3 04             	add    $0x4,%ebx
80106d58:	05 00 00 00 80       	add    $0x80000000,%eax
80106d5d:	50                   	push   %eax
80106d5e:	e8 8d b5 ff ff       	call   801022f0 <kfree>
80106d63:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d66:	39 fb                	cmp    %edi,%ebx
80106d68:	75 dd                	jne    80106d47 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d70:	5b                   	pop    %ebx
80106d71:	5e                   	pop    %esi
80106d72:	5f                   	pop    %edi
80106d73:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d74:	e9 77 b5 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d79:	83 ec 0c             	sub    $0xc,%esp
80106d7c:	68 d9 78 10 80       	push   $0x801078d9
80106d81:	e8 ea 95 ff ff       	call   80100370 <panic>
80106d86:	8d 76 00             	lea    0x0(%esi),%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d91:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d93:	89 e5                	mov    %esp,%ebp
80106d95:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9e:	e8 7d f8 ff ff       	call   80106620 <walkpgdir>
  if(pte == 0)
80106da3:	85 c0                	test   %eax,%eax
80106da5:	74 05                	je     80106dac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106da7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106daa:	c9                   	leave  
80106dab:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 ea 78 10 80       	push   $0x801078ea
80106db4:	e8 b7 95 ff ff       	call   80100370 <panic>
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
80106dc6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106dc9:	e8 52 fb ff ff       	call   80106920 <setupkvm>
80106dce:	85 c0                	test   %eax,%eax
80106dd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dd3:	0f 84 b2 00 00 00    	je     80106e8b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ddc:	85 c9                	test   %ecx,%ecx
80106dde:	0f 84 9c 00 00 00    	je     80106e80 <copyuvm+0xc0>
80106de4:	31 f6                	xor    %esi,%esi
80106de6:	eb 4a                	jmp    80106e32 <copyuvm+0x72>
80106de8:	90                   	nop
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106df0:	83 ec 04             	sub    $0x4,%esp
80106df3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106df9:	68 00 10 00 00       	push   $0x1000
80106dfe:	57                   	push   %edi
80106dff:	50                   	push   %eax
80106e00:	e8 5b d7 ff ff       	call   80104560 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e05:	58                   	pop    %eax
80106e06:	5a                   	pop    %edx
80106e07:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e10:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e13:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e18:	52                   	push   %edx
80106e19:	89 f2                	mov    %esi,%edx
80106e1b:	e8 80 f8 ff ff       	call   801066a0 <mappages>
80106e20:	83 c4 10             	add    $0x10,%esp
80106e23:	85 c0                	test   %eax,%eax
80106e25:	78 3e                	js     80106e65 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e27:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e2d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e30:	76 4e                	jbe    80106e80 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e32:	8b 45 08             	mov    0x8(%ebp),%eax
80106e35:	31 c9                	xor    %ecx,%ecx
80106e37:	89 f2                	mov    %esi,%edx
80106e39:	e8 e2 f7 ff ff       	call   80106620 <walkpgdir>
80106e3e:	85 c0                	test   %eax,%eax
80106e40:	74 5a                	je     80106e9c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e42:	8b 18                	mov    (%eax),%ebx
80106e44:	f6 c3 01             	test   $0x1,%bl
80106e47:	74 46                	je     80106e8f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e49:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e4b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e51:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e54:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106e5a:	e8 41 b6 ff ff       	call   801024a0 <kalloc>
80106e5f:	85 c0                	test   %eax,%eax
80106e61:	89 c3                	mov    %eax,%ebx
80106e63:	75 8b                	jne    80106df0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106e65:	83 ec 0c             	sub    $0xc,%esp
80106e68:	ff 75 e0             	pushl  -0x20(%ebp)
80106e6b:	e8 a0 fe ff ff       	call   80106d10 <freevm>
  return 0;
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e78:	5b                   	pop    %ebx
80106e79:	5e                   	pop    %esi
80106e7a:	5f                   	pop    %edi
80106e7b:	5d                   	pop    %ebp
80106e7c:	c3                   	ret    
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e86:	5b                   	pop    %ebx
80106e87:	5e                   	pop    %esi
80106e88:	5f                   	pop    %edi
80106e89:	5d                   	pop    %ebp
80106e8a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106e8b:	31 c0                	xor    %eax,%eax
80106e8d:	eb e6                	jmp    80106e75 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106e8f:	83 ec 0c             	sub    $0xc,%esp
80106e92:	68 0e 79 10 80       	push   $0x8010790e
80106e97:	e8 d4 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106e9c:	83 ec 0c             	sub    $0xc,%esp
80106e9f:	68 f4 78 10 80       	push   $0x801078f4
80106ea4:	e8 c7 94 ff ff       	call   80100370 <panic>
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106eb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106eb1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106eb3:	89 e5                	mov    %esp,%ebp
80106eb5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebe:	e8 5d f7 ff ff       	call   80106620 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ec3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106ec5:	89 c2                	mov    %eax,%edx
80106ec7:	83 e2 05             	and    $0x5,%edx
80106eca:	83 fa 05             	cmp    $0x5,%edx
80106ecd:	75 11                	jne    80106ee0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ecf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106ed4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ed5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106eda:	c3                   	ret    
80106edb:	90                   	nop
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106ee0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ee2:	c9                   	leave  
80106ee3:	c3                   	ret    
80106ee4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ef0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106efc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f02:	85 db                	test   %ebx,%ebx
80106f04:	75 40                	jne    80106f46 <copyout+0x56>
80106f06:	eb 70                	jmp    80106f78 <copyout+0x88>
80106f08:	90                   	nop
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f13:	89 f1                	mov    %esi,%ecx
80106f15:	29 d1                	sub    %edx,%ecx
80106f17:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f1d:	39 d9                	cmp    %ebx,%ecx
80106f1f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f22:	29 f2                	sub    %esi,%edx
80106f24:	83 ec 04             	sub    $0x4,%esp
80106f27:	01 d0                	add    %edx,%eax
80106f29:	51                   	push   %ecx
80106f2a:	57                   	push   %edi
80106f2b:	50                   	push   %eax
80106f2c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f2f:	e8 2c d6 ff ff       	call   80104560 <memmove>
    len -= n;
    buf += n;
80106f34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f37:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f3a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f40:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f42:	29 cb                	sub    %ecx,%ebx
80106f44:	74 32                	je     80106f78 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f46:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f48:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f4e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f54:	56                   	push   %esi
80106f55:	ff 75 08             	pushl  0x8(%ebp)
80106f58:	e8 53 ff ff ff       	call   80106eb0 <uva2ka>
    if(pa0 == 0)
80106f5d:	83 c4 10             	add    $0x10,%esp
80106f60:	85 c0                	test   %eax,%eax
80106f62:	75 ac                	jne    80106f10 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f6c:	5b                   	pop    %ebx
80106f6d:	5e                   	pop    %esi
80106f6e:	5f                   	pop    %edi
80106f6f:	5d                   	pop    %ebp
80106f70:	c3                   	ret    
80106f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f7b:	31 c0                	xor    %eax,%eax
}
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
80106f81:	c3                   	ret    
