insert into people values ('홍길동', '1988-03-12', phone_tab(), addr_tab());
insert into people values ('홍길동2', '1988-03-12', phone_tab(), addr_tab());
insert into table(select addresses from people where name = '홍길동')
    values (addr_ty('부산시','수영구','수영동'));
insert into table(select address from people where name = '홍길동2')
        values (addr_ty('mobile', 2, '010-9877-5612'));
insert into table(select address from people where name = '홍길동2')
        values (addr_ty('mobile', 3, '010-9877-5612'));
        
insert into people values ('홍길동3', '2000-10-12',
    phone_tab(phone_ty('mobile', 1, '010-1234-1223'), phone_ty('home', 2, '051-1234-1223')), 
    addr_tab(addr_ty('부산시', '남구', '대연동'), 
            addr_ty('서울시', '남구', '대연동'),
            addr_ty('울산시', '남구', '대연동'))
);
