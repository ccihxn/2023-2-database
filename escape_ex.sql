select * from movie where title like '%of%';

select * from movie where title like '%K%%' escape 'K';

select * from movie where title like '%'||'K'||'%'||'%' escape 'K';
/*\n 같은 경우는 \가 n이 기능을 하게 도와주는 escape라고 한다. 
그러므로 escape 'K'는 K문자를 \ 역할을 하게 하는 문법이다.*/