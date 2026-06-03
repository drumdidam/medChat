import { Resend } from 'resend';

export async function sendVerificationMail(email: string, token: string) {
	const url = `http://localhost:3000/auth/verify?token=${token}`

	console.log(email);

	const resend = new Resend('re_9Y3hijiS_DiaVVXoumxULy6ggVWZEf5Qv');

	const result = await resend.emails.send({
		from: 'noreply@dev.sernaglia.at',
		to: `${email}`,
		subject: 'Hello World',
		html: `
  <h2>Welcome to medChat</h2>
  <p>Please verfiy your Account by clicking this link</p>
  <a href="${url}">Verify NOW!</a>
  <p>Your link is valid for 24 hours</p>
  `
	});

	console.log('Resend result:', result);
}
